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


def plan(ftp, source):
    originals = {
        item['path']: item['sha256']
        for item in json.loads((source / 'docs/seo-originals.json').read_text())['files']
    }
    before, target, changed, drift = {}, {}, [], []
    for path in FILES:
        before[path] = read_remote(ftp, path)
        target[path] = (source / path).read_bytes()
        if len(target[path]) > MAX_BYTES:
            raise RuntimeError('Local file exceeds limit: ' + path)
        current = digest(before[path])
        expected = originals.get(path, 'absent')
        wanted = digest(target[path])
        status = 'already deployed' if current == wanted else 'ready'
        accepted = {expected, wanted}
        if path in PREVIOUS_STAGE_HASHES:
            accepted.update(PREVIOUS_STAGE_HASHES[path])
        if current not in accepted:
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
        print('All allowlisted files already match; no writes.')
        return
    encrypted = encrypted_backup(before)
    print('Step: prepare dedicated dev SEO backup directory', flush=True)
    ftp.cwd('/')
    names = {item.rstrip('/').rsplit('/', 1)[-1] for item in ftp.nlst()}
    if BACKUP_DIRECTORY not in names:
        ftp.mkd(BACKUP_DIRECTORY)
    backup_path = BACKUP_DIRECTORY + '/seo-' + uuid.uuid4().hex + '.tar.gz.enc'
    print('Step: upload and read back encrypted backup in', BACKUP_DIRECTORY, flush=True)
    write_remote(ftp, backup_path, encrypted)
    print('Verified encrypted backup:', backup_path, 'sha256:', digest(encrypted))
    # Check again after the backup, before starting any replacement.
    for path in FILES:
        if read_remote(ftp, path) != before[path]:
            raise RuntimeError('Concurrent change detected; no SEO files replaced: ' + path)
    previous_nodes = sitemap_nodes(False)
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
        verify_dev(previous_nodes)
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
    print('Deployed and verified selected SEO files. Browser/CMS validation is still required.')


def fetch_dev(path):
    with urllib.request.urlopen('https://dev.zelseptik.ru' + path, timeout=45) as response:
        if response.status != 200:
            raise RuntimeError('Unexpected dev response status')
        return response.read()


def sitemap_nodes(require_index):
    xml = fetch_dev('/sitemap.xml')
    if not require_index:
        # The reviewed baseline has a complete urlset followed by the known error.
        xml = xml.split(b'\nSitemap error. See Log.')[0]
    root = ET.fromstring(xml)
    ns = '{http://www.sitemaps.org/schemas/sitemap/0.9}'
    if root.tag == ns + 'urlset' and not require_index:
        return {x.text for x in root.findall(ns + 'url/' + ns + 'loc')}
    if root.tag != ns + 'sitemapindex':
        raise RuntimeError('Expected a valid sitemap index')
    nodes = set()
    children = root.findall(ns + 'sitemap/' + ns + 'loc')
    if not children or len(children) > 20:
        raise RuntimeError('Unexpected sitemap child count')
    for child in children:
        url = urllib.parse.urlsplit(child.text)
        if url.scheme != 'https' or url.netloc not in ('zelseptik.ru', 'dev.zelseptik.ru') or not url.path.startswith('/hostcmsfiles/sitemap/') or url.query:
            raise RuntimeError('Unexpected sitemap child location')
        tree = ET.fromstring(fetch_dev(url.path))
        if tree.tag != ns + 'urlset':
            raise RuntimeError('Invalid child sitemap root')
        nodes.update(x.text for x in tree.findall(ns + 'url/' + ns + 'loc'))
    return nodes


def verify_dev(previous_nodes):
    first = sitemap_nodes(True)
    second = sitemap_nodes(True)
    if first != previous_nodes or second != first:
        raise RuntimeError('Sitemap URL set changed or repeated generation failed')
    page = fetch_dev('/catalog/').decode('utf-8')
    if len(re.findall(r'<h1(?:\s|>)', page, flags=re.I)) != 1 or '<h2 class="h-2">Каталог продукции:</h2>' not in page:
        raise RuntimeError('Regional server headings failed QA')
    if not re.search(r'name=[\"\']robots[\"\'][^>]+content=[\"\']noindex, nofollow', page):
        raise RuntimeError('Dev indexing protection changed')
    print('Public QA passed: valid index and child XML, repeated generation, unchanged', len(first), 'URLs; single server H1 and dev noindex.')


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
        # Permission replies identify the rejected operation; never expose passwords
        # or subprocess command arguments. GitHub also masks the repository secret.
        if isinstance(error, (RuntimeError, ftplib.error_perm, ftplib.error_temp)):
            message = str(error).replace(os.environ.get('DEV_FTP_PASSWORD') or '\0', '[redacted]')
            print('Stopped:', message.replace('\r', ' ').replace('\n', ' '))
        else:
            print('Stopped:', type(error).__name__)
        raise SystemExit(1)
