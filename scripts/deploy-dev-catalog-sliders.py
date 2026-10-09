"""Deploy the reviewed native HostCMS filter XSL to isolated dev."""
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



FILES = {'hostcmsfiles/xsl/55.xsl': '1e063e26d9fd6f68dbcb27ef1ed600a18c7ec1806a0cf398c821bc38ee0bb63e', 'templates/template1/script.js': '55b385b00bcbcd9bc04457ee27cb109725108068eb334a115f4a986cde4750d9', 'assets/css/information-pages.css': '762e25bfa2038b0e0029be16f6349f7feca87ade3d81a542c2a58f350e11be32', 'hostcmsfiles/lib/lib_6/lib_6.php': '002ee0942d0eb262ca9ea6b0393b7e0a8dd863895f81940a273f47ff042e923e'}

def main():
    targets = {path: Path(path).read_bytes() for path in FILES}
    ftp = ftplib.FTP(timeout=45)
    before = {}
    changed = []
    try:
        ftp.connect('92.63.102.79', 21)
        ftp.login('zelseptik', os.environ['DEV_FTP_PASSWORD'])
        ftp.set_pasv(True)
        before = {path: read_remote(ftp, path) for path in FILES}
        for path, data in before.items():
            if data != targets[path] and digest(data) != FILES[path]:
                raise RuntimeError('File changed since review; no writes: ' + path)
        if all(before[path] == targets[path] for path in FILES):
            print('Already deployed')
            return
        backup = BACKUP_DIRECTORY + '/catalog-sliders-' + uuid.uuid4().hex + '.tar.gz.enc'
        write_remote(ftp, backup, encrypted_backup(before))
        print('Verified encrypted backup:', backup)
        if any(read_remote(ftp, path) != before[path] for path in FILES):
            raise RuntimeError('Concurrent change; no replacement')
        try:
            for path in FILES:
                if before[path] != targets[path]:
                    changed.append(path)
                    write_remote(ftp, path, targets[path])
        except BaseException:
            for path in reversed(changed):
                write_remote(ftp, path, before[path])
            print('Original files restored')
            raise
        print('Verified native catalog range sliders on isolated dev')
    finally:
        ftp.close()

if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print('Stopped:', type(error).__name__, str(error))
        raise SystemExit(1)
