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



PATH = 'assets/css/information-pages.css'
EXPECTED = '21be1f19894fda161b0074f7c414bae769252e55f4d1c3737a8ca1e5c1f758c6'

def main():
    target = Path(PATH).read_bytes()
    ftp = ftplib.FTP(timeout=45)
    try:
        ftp.connect('92.63.102.79', 21)
        ftp.login('zelseptik', os.environ['DEV_FTP_PASSWORD'])
        ftp.set_pasv(True)
        before = read_remote(ftp, PATH)
        if before == target:
            print('Already deployed')
            return
        if digest(before) != EXPECTED:
            raise RuntimeError('CSS changed since review; no writes')
        backup = BACKUP_DIRECTORY + '/area-photo-' + uuid.uuid4().hex + '.tar.gz.enc'
        write_remote(ftp, backup, encrypted_backup({PATH: before}))
        print('Verified encrypted backup:', backup)
        if read_remote(ftp, PATH) != before:
            raise RuntimeError('Concurrent CSS change; no replacement')
        try:
            write_remote(ftp, PATH, target)
        except BaseException:
            write_remote(ftp, PATH, before)
            print('Original CSS restored')
            raise
        print('Verified service photo CSS:', digest(target))
    finally:
        ftp.close()

if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print('Stopped:', type(error).__name__)
        raise SystemExit(1)
