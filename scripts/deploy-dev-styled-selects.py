"""Deploy the fixed SEO stage to isolated dev; no arbitrary paths or force mode."""
import argparse
import ftplib
import hashlib
import io
import json
import os
from pathlib import Path
import re
import subprocess
import tarfile
import uuid
import urllib.request
import urllib.parse
import xml.etree.ElementTree as ET

FILES = ('templates/template13/template.htm', 'hostcmsfiles/lib/lib_29/lib_config_29.php')
MAX_BYTES = 4 * 1024 * 1024
BACKUP_DIRECTORY = '.ui-deploy-backups'
TEMPLATE1 = 'templates/template1/template.htm'
PREVIOUS_STAGE_HASHES = {}


def digest(data):
    return hashlib.sha256(data).hexdigest() if data is not None else 'absent'


def read_remote(ftp, path):
    parent, name = path.rsplit('/', 1)
    ftp.cwd('/' + parent)
    names = {entry.rstrip('/').rsplit('/', 1)[-1] for entry in ftp.nlst()}
    if name not in names:
        return None
    result = io.BytesIO()

    def collect(chunk):
        if result.tell() + len(chunk) > MAX_BYTES:
            raise RuntimeError('Remote file exceeds size limit: ' + path)
        result.write(chunk)

    ftp.retrbinary('RETR ' + name, collect)
    return result.getvalue()


def write_remote(ftp, path, data):
    parent, name = path.rsplit('/', 1)
    ftp.cwd('/' + parent)
    ftp.storbinary('STOR ' + name, io.BytesIO(data))
    if read_remote(ftp, path) != data:
        raise RuntimeError('Uploaded bytes differ: ' + path)


def encrypted_backup(before):
    output = io.BytesIO()
    manifest = {path: {'present': data is not None, 'sha256': digest(data)}
                for path, data in before.items()}
    with tarfile.open(fileobj=output, mode='w:gz') as archive:
        entries = {'manifest.json': json.dumps(manifest).encode()}
        entries.update({path: data for path, data in before.items() if data is not None})
        for path, data in entries.items():
            info = tarfile.TarInfo(path)
            info.size = len(data)
            info.mode = 0o600
            archive.addfile(info, io.BytesIO(data))
    args = ['openssl', 'enc', '-aes-256-cbc', '-pbkdf2', '-iter', '200000',
            '-md', 'sha256', '-pass', 'env:DEV_FTP_PASSWORD']
    encrypted = subprocess.run(args, input=output.getvalue(), capture_output=True, check=True).stdout
    decrypted = subprocess.run(args + ['-d'], input=encrypted, capture_output=True, check=True).stdout
    if decrypted != output.getvalue():
        raise RuntimeError('Backup encryption round-trip failed')
    return encrypted



EXPECTED = {'assets/js/modules/dropdown.js': 'f46d03922268e7dbd982bc6cb62639752cbf0af25c8526d92d0420afd542944d', 'assets/js/app.js': 'c2d8370ee8577906eb95b2eae084d5af0a8f41b0c6bed301845cfc9e42e317bd', 'assets/css/information-pages.css': '3b0fee928cf0d9bf3cdcf60440ff9546a25042e543e21f01c779d3e103844629', 'hostcmsfiles/xsl/55.xsl': '7bbd455243d618789d72d46b6814e9f6fb7aeadd9fe921cedd8ba133477e0a90'}

def main():
    target = {p: Path(p).read_bytes() for p in EXPECTED}
    ftp = ftplib.FTP(timeout=45)
    try:
        ftp.connect('92.63.102.79', 21)
        ftp.login('zelseptik', os.environ['DEV_FTP_PASSWORD'])
        ftp.set_pasv(True)
        before = {p: read_remote(ftp, p) for p in EXPECTED}
        for p in EXPECTED:
            if digest(before[p]) not in (EXPECTED[p], digest(target[p])):
                raise RuntimeError('Drift detected; no writes')
        changed = [p for p in EXPECTED if before[p] != target[p]]
        if not changed:
            print('Already deployed')
            return
        backup = BACKUP_DIRECTORY + '/styled-selects-' + uuid.uuid4().hex + '.tar.gz.enc'
        write_remote(ftp, backup, encrypted_backup(before))
        print('Verified encrypted backup:', backup)
        for p in EXPECTED:
            if read_remote(ftp, p) != before[p]:
                raise RuntimeError('Concurrent change; no replacement')
        touched = []
        try:
            for p in changed:
                if read_remote(ftp, p) != before[p]:
                    raise RuntimeError('Concurrent change')
                touched.append(p)
                write_remote(ftp, p, target[p])
                print('Verified:', p)
        except BaseException:
            for p in reversed(touched):
                write_remote(ftp, p, before[p])
            print('All attempted replacements restored')
            raise
    finally:
        ftp.close()

if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print('Stopped:', type(error).__name__)
        raise SystemExit(1)
