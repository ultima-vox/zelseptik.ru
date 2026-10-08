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



FILES = {
    'hostcmsfiles/xsl/55.xsl': '87e63ec44f84138eb708cc61f976264ea101c8b542aca29aa83953b1b444b703',
    'templates/template1/script.js': 'e3d0f797502c6d666a46134f160841e9523b6cec3d7e5cc6359d29271fad71ef',
    'assets/css/information-pages.css': '948647f686bca5e3a4432713a15bbf89e6430e7bd3eb8f7e30811f05bf0d9744',
    'hostcmsfiles/lib/lib_6/lib_6.php': '16c18e65f77d38858b75870e2a3062894e095d12baa441718cde4284bdfa9ea0',
}

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
