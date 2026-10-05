"""Deploy the fixed UI stage to isolated dev; no arbitrary paths or force mode."""
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

FILES = (
    'assets/css/information-pages.css',
    'assets/js/modules/information.js',
    'assets/js/app.js',
    'templates/template3/script.js',
    'hostcmsfiles/xsl/13.xsl',
    'hostcmsfiles/xsl/4.xsl',
    'templates/template3/template.htm',
    'templates/template1/template.htm',
)
MAX_BYTES = 4 * 1024 * 1024
TEMPLATE1 = 'templates/template1/template.htm'
# Actual dev hash observed by the read-only run 37314881595.
DEV_TEMPLATE1_SHA = '696f886b5d2b140a58e5a04609ea5b5992a14734686b9cbb722fa6eb8979de8a'


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


def patch_current_template(current, original_sha):
    """Add only one known CSS call; preserve all current dev PHP and settings."""
    if current is None:
        raise RuntimeError('Main dev template is missing')
    accepted = {original_sha, DEV_TEMPLATE1_SHA}
    css_call = b"->css('/assets/css/information-pages.css')"
    # Match an active chained call on its own line, excluding commented examples.
    pattern = rb'(?m)^([ \t]*)->showCss\(\);[ \t]*(\r?\n|$)'
    if digest(current) in accepted:
        matches = list(re.finditer(pattern, current))
        if len(matches) != 1 or b'/assets/css/information-pages.css' in current:
            raise RuntimeError('Main template CSS anchor is ambiguous; no replacement')
        match = matches[0]
        newline = match.group(2) or b'\n'
        insertion = match.group(1) + css_call + newline
        return current[:match.start()] + insertion + current[match.start():]
    installed = rb"(?m)^[ \t]*->css\('/assets/css/information-pages\.css'\)\r?\n"
    inserted = list(re.finditer(installed, current))
    if len(inserted) == 1:
        match = inserted[0]
        restored = current[:match.start()] + current[match.end():]
        if digest(restored) in accepted and patch_current_template(restored, original_sha) == current:
            return current
    raise RuntimeError('Main template changed since inspection; requires review')


def plan(ftp, source):
    originals = {
        item['path']: item['sha256']
        for item in json.loads((source / 'docs/ui-originals.json').read_text())['files']
    }
    before, target, changed, drift = {}, {}, [], []
    for path in FILES:
        before[path] = read_remote(ftp, path)
        target[path] = (source / path).read_bytes()
        if path == TEMPLATE1:
            target[path] = patch_current_template(before[path], originals[path])
        if len(target[path]) > MAX_BYTES:
            raise RuntimeError('Local file exceeds limit: ' + path)
        current = digest(before[path])
        expected = originals.get(path, 'absent')
        wanted = digest(target[path])
        status = 'already deployed' if current == wanted else 'ready'
        if path != TEMPLATE1 and current not in (expected, wanted):
            status = 'DRIFT: requires review'
            drift.append(path)
        elif current != wanted:
            changed.append(path)
        print(json.dumps({'path': path, 'current_sha256': current,
                          'target_sha256': wanted, 'status': status}))
    if drift:
        raise RuntimeError('Dev differs from baseline; no files changed: ' + ', '.join(drift))
    return before, target, changed


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


def deploy(ftp, source, mode):
    before, target, changed = plan(ftp, source)
    if mode == 'inspect':
        print('Inspection complete; no writes.')
        return
    if not changed:
        print('All eight files already match; no writes.')
        return
    encrypted = encrypted_backup(before)
    ftp.cwd('/')
    names = {item.rstrip('/').rsplit('/', 1)[-1] for item in ftp.nlst()}
    if '.codex-backups' not in names:
        ftp.mkd('.codex-backups')
    backup_path = '.codex-backups/service-ui-' + uuid.uuid4().hex + '.tar.gz.enc'
    write_remote(ftp, backup_path, encrypted)
    print('Verified encrypted backup:', backup_path, 'sha256:', digest(encrypted))
    # Check again after the backup, before starting any replacement.
    for path in FILES:
        if read_remote(ftp, path) != before[path]:
            raise RuntimeError('Concurrent change detected; no UI files replaced: ' + path)
    touched = []
    try:
        for path in changed:
            if read_remote(ftp, path) != before[path]:
                raise RuntimeError('Concurrent change detected: ' + path)
            touched.append(path)  # includes an interrupted upload
            write_remote(ftp, path, target[path])
            print('Verified upload:', path)
        for path in FILES:
            if read_remote(ftp, path) != target[path]:
                raise RuntimeError('Final verification failed: ' + path)
    except BaseException:
        failed = []
        for path in reversed(touched):
            try:
                if before[path] is None:
                    parent, name = path.rsplit('/', 1)
                    ftp.cwd('/' + parent)
                    ftp.delete(name)
                    if read_remote(ftp, path) is not None:
                        raise RuntimeError('Rollback removal failed')
                else:
                    write_remote(ftp, path, before[path])
            except Exception:
                failed.append(path)
        if failed:
            print('ROLLBACK INCOMPLETE:', ', '.join(failed), 'use encrypted backup:', backup_path)
        else:
            print('All attempted replacements rolled back.')
        raise
    print('Deployed and verified eight UI files. Browser/CMS validation is still required.')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--source', type=Path, required=True)
    parser.add_argument('--mode', choices=('inspect', 'deploy'), default='inspect')
    args = parser.parse_args()
    if not os.environ.get('DEV_FTP_PASSWORD'):
        raise RuntimeError('Repository secret DEV_FTP_PASSWORD is missing')
    ftp = ftplib.FTP(timeout=45)
    try:
        ftp.connect('92.63.102.79', 21)
        ftp.login('zelseptik', os.environ['DEV_FTP_PASSWORD'])
        ftp.set_pasv(True)
        deploy(ftp, args.source, args.mode)
        ftp.quit()
    finally:
        ftp.close()


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        # Never log server replies or subprocess arguments containing credentials.
        print('Stopped:', str(error) if type(error) is RuntimeError else type(error).__name__)
        raise SystemExit(1)
