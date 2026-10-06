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
    'templates/template1/script.js',
    'templates/template3/script.js',
    'hostcmsfiles/xsl/13.xsl',
    'hostcmsfiles/xsl/4.xsl',
    'hostcmsfiles/xsl/3.xsl',
    'hostcmsfiles/xsl/55.xsl',
    'hostcmsfiles/xsl/56.xsl',
    'hostcmsfiles/xsl/83.xsl',
    'hostcmsfiles/xsl/278.xsl',
    'hostcmsfiles/xsl/279.xsl',
    'hostcmsfiles/xsl/280.xsl',
    'hostcmsfiles/xsl/281.xsl',
    'hostcmsfiles/xsl/282.xsl',
    'templates/template3/template.htm',
    'templates/template1/template.htm',
)
MAX_BYTES = 4 * 1024 * 1024
BACKUP_DIRECTORY = '.ui-deploy-backups'
TEMPLATE1 = 'templates/template1/template.htm'
# Actual dev hash observed by the read-only run 37314881595.
DEV_TEMPLATE1_SHA = '696f886b5d2b140a58e5a04609ea5b5992a14734686b9cbb722fa6eb8979de8a'
# Accept only the original files and previously verified UI stage bytes.
PREVIOUS_STAGE_HASHES = {
    'hostcmsfiles/xsl/279.xsl': ('2aaf791defe33c951137a0ed36dca87c033a8f6b0ba18019d27fb44476a90ab0',),
    'hostcmsfiles/xsl/56.xsl': ('3ee467693f502bb3651319860a4042a08862b7440cd58c562d14643f80c59f50',),
    'hostcmsfiles/xsl/3.xsl': ('4a2cffc4ea4a2454f4e4c7f2efdf2e35d09efad91da815cc0bad1d8e1856a6f4',),
    'hostcmsfiles/xsl/13.xsl': ('c95108ada8a35ff2d629056a56407495b88ccd56606d0de5c89d09cc0496b145',),
    'templates/template1/script.js': (
        '2a9a6601fbb7c8f707161054c77d0e7c68bc581ca803c4c30dcd1418dba8a78e',
        '2ee0e3c5c2bc6cec8f72685cfff11ead7da3af88cc737485f7d85a15a782508b','a31020470633ee8b2a1447eda2eaa592a4bfd973fa76a98bce72c546724ed9bc',),
    'assets/css/information-pages.css': ('5c9e786221ab15351790c9753d15d30c283c414fe7c43d8565bad54c217f1d01', 
        '1f94af1d8fd4eb5ed1efacd21c46c56002c4f76fb9066fdb496474c8a5c3b364',
        '1034471b69cd3d4bd7e022308147caeeb2db3549d78780339a5bdadc488e895c',
        'fe025c1621f558f670d92bfab3aa79c4db74544734284d0d85a234f431a2f6f9',
        '79cce5223bdbc35caa4a29578e67ea1f068113c5a2bc238417f62cfb996d8dcf',
        '922b0d10f47469ac980709e6103375c5a8509a106f11a12b3b4792581e317aaa',
        'eb4e8c7670a45415a659e4ee669740e004f514f52fc0f888b4cdd64dc1119f61',
        'afe15f3e1a655caa27c4f329a9fd9a1ba231654670457d815c1532fae489dc7f',
        '2b65382dda571413a6adb4f36648166042debb705b45bc6ee6dd6f2ecf1d0cf9',
        '9a9635374631b7eb20022ef54540be0a98f4a4d2862cafa4a750c58f2ec14455',
        '367155eda6b308ffc58f93146834fdd8b4c38b19d6dd538b24bf89b0885409eb',
        '3006e4d042dff5eddb296775056f73885c9052c1b4421de3922789a70a70f5df',
        '21675724534e19f7b86bb2a027f96ccdbd7f050beddd19a5af1fa2ea2508d262',
        '59e8459b2fe2ddf512f50e2a44994a13c23106579cf289eca8712708705b99a5',
        'a02e7765191809823bdd65e2a6a96c426f81c649f344843d8d6995fd1d801ad7',
        'b4d9775efb4e91a1ce21cdd9326f6720119357190d4e5613b054131bdb416b0c',
        '7149b84bb45097a1b0cbe1ce090ccd7066385971a304832ebc7f86ab8cad9972',
        '0b741df1d27358a221c4d2f93bba15b3896116e68c05268f91599a67437af9c2',
    ),
    'hostcmsfiles/xsl/4.xsl': (
        'a5603c5d340bd49bd03afd52ab1964120eaab85de9b886a16ab3cea3f508249c',
        '399fbaa155b4fbe6968c2074c14274d35646bcb7f47b15b83b884d0f7590c9af',
        '974965842bec5e026148921a738ee6e2c6dde55346428939dbca9c75cfed640b',
    ),
    'assets/js/modules/information.js': ('cc0ebc1607098b11889c228149bf4d683ccf9cc2a373fe33d83a178f3f47ba2c', 
        'd1dc4b46b1c34f1aec1404549705fc673821836e1926d17e6046925a70bcd577',
        '8a705a84334c9ec4d357b334e516cfbce16387a11beaa0cc22923afaf471bd78','6bb7cb69d9c2d8153c7cb5a39c1ca350e8e1194cf741580e7f90e8635f9d338b', '12509feaec8470ffaa7f04c6fb29521cdd36bf786ea4285b1ce780aa6618a912'),
    'hostcmsfiles/xsl/282.xsl': ('d871b02aaaa510baf35532751c2a491dc3a251e910257dc27eba6f12cb326cd8',),
    'hostcmsfiles/xsl/280.xsl': ('351360e6273af8506c15ca6280619ea520e5a4a283fe55ace7d1574e274dd89a', '62839148c05974d4cde9531040e51843f0d78fdb5efe8ef3ab30a0ce3236b2ba',),
    'assets/js/app.js': ('1f4faa2974f39594b91a49f0e5361b18b95618017645be8e0ded46145474cbf6', 
        '14a2f34e39b04e2d2156eafdbeb6ff177bd6d29ec84f0836d4a771b29a46ca0e',
        '4cd8c5ee3a74cd47d3175b19e5190479c9e627e5c316bbab6278a0f2ac6edb95','356800bf1963a6f0fb9341bd9562c12a7f0856f5fe59ab8a867b8bd7d1b2be00', '932a8628510a464c302a84a96ab09498ce6992f7923aad81cce2662af0d3873b'),
}


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
        accepted = {expected, wanted}
        if path in PREVIOUS_STAGE_HASHES:
            accepted.update(PREVIOUS_STAGE_HASHES[path])
        if path != TEMPLATE1 and current not in accepted:
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
    print('Step: prepare dedicated dev UI backup directory', flush=True)
    ftp.cwd('/')
    names = {item.rstrip('/').rsplit('/', 1)[-1] for item in ftp.nlst()}
    if BACKUP_DIRECTORY not in names:
        ftp.mkd(BACKUP_DIRECTORY)
    backup_path = BACKUP_DIRECTORY + '/service-ui-' + uuid.uuid4().hex + '.tar.gz.enc'
    print('Step: upload and read back encrypted backup in', BACKUP_DIRECTORY, flush=True)
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
    print('Deployed and verified selected UI files. Browser/CMS validation is still required.')


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
