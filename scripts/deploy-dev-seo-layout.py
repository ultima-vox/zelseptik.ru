"""Deploy the reviewed landing-description XSL/CSS to isolated dev with drift guards."""
import ftplib
import hashlib
import io
import json
import os
from pathlib import Path
import subprocess
import tarfile
import uuid

MAX_BYTES = 4 * 1024 * 1024
BACKUP_DIRECTORY = '.ui-deploy-backups'


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



EXPECTED = {'templates/template1/template.htm': '53c491c7c5c20153849e231c2a75d0ebfe38b41bf0e5a6dd21fcb2a712f337d3', 'hostcmsfiles/xsl/55.xsl': '5e546874dbc3215cb9ac5c06dafc2c7c5e93d39389c943921a57fcfb87d63e00', 'hostcmsfiles/xsl/3.xsl': '128b7bfc18fbe425a8a81518d64bf17d41409cff7dd32a17d410f58f690bc2b4', 'assets/css/information-pages.css': 'dc3726e7d4fc5ac516fdf5ce8e26a1738d8602d843e2aadfb0f637d2a9b30165', 'hostcmsfiles/xsl/6.xsl': 'f75b00d2e1f3c69d03655c4e804b0c3d58d1ac3e4d7af4dbb5b54c8acf8b8ab2', 'hostcmsfiles/xsl/176.xsl': 'f6b47b751b86e0d7a81a299932acb76ad2f2d159c5fad30729f8e53cf7aa6bf6'}

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
        backup = BACKUP_DIRECTORY + '/seo-layout-' + uuid.uuid4().hex + '.tar.gz.enc'
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
