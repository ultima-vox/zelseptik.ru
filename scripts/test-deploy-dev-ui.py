import contextlib
import importlib.util
import io
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('deployment', Path(__file__).with_name('deploy-dev-ui.py'))
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class FakeFTP:
    def __init__(self, files):
        self.files = dict(files)
        self.directory = ''
        self.writes = []
        self.corrupt_once = None

    def cwd(self, path):
        self.directory = path.strip('/')

    def nlst(self):
        prefix = self.directory + '/' if self.directory else ''
        return sorted({path[len(prefix):].split('/')[0] for path in self.files if path.startswith(prefix)})

    def mkd(self, name):
        pass

    def retrbinary(self, command, collect):
        collect(self.files[self.directory + '/' + command[5:]])

    def storbinary(self, command, source):
        path = self.directory + '/' + command[5:]
        data = source.read()
        self.writes.append(path)
        if self.corrupt_once and self.corrupt_once in path:
            data = b'corrupted upload'
            self.corrupt_once = None
        self.files[path] = data

    def delete(self, name):
        del self.files[self.directory + '/' + name]


class DeploymentTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.source = Path(self.tmp.name)
        self.before = {}
        originals = []
        for index, path in enumerate(module.FILES):
            target = self.source / path
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(('new ' + path).encode())
            if index >= 2:
                self.before[path] = ('old ' + path).encode()
                if path == module.TEMPLATE1:
                    self.before[path] = (b'dev settings must remain\r\n'
                        b'        ->fileTimestamp(TRUE)\r\n'
                        b"        ->prependCss('/assets/css/runtime.min.css')\r\n"
                        b"        ->prependCss('/assets/css/app.min.css')\r\n"
                        b'        ->showCss();\r\n')
                originals.append({'path': path, 'sha256': module.digest(self.before[path])})
        (self.source / 'docs').mkdir()
        (self.source / 'docs/ui-originals.json').write_text(json.dumps({'files': originals}))
        self.ftp = FakeFTP(self.before)

    def execute(self, mode):
        with contextlib.redirect_stdout(io.StringIO()), patch.object(module, 'encrypted_backup', return_value=b'encrypted'):
            module.deploy(self.ftp, self.source, mode)

    def test_inspection_never_writes(self):
        self.execute('inspect')
        self.assertEqual(self.ftp.writes, [])

    def test_drift_aborts_before_backup(self):
        self.ftp.files[module.FILES[-1]] = b'edited on dev'
        with self.assertRaises(RuntimeError):
            self.execute('deploy')
        self.assertEqual(self.ftp.writes, [])

    def test_verified_backup_precedes_uploads_and_rerun_is_noop(self):
        self.execute('deploy')
        self.assertTrue(self.ftp.writes[0].startswith('.codex-backups/'))
        self.assertEqual(self.ftp.writes[1:], list(module.FILES))
        for path in module.FILES:
            if path == module.TEMPLATE1:
                self.assertIn(b'dev settings must remain', self.ftp.files[path])
                self.assertEqual(self.ftp.files[path].count(b'/assets/css/information-pages.css'), 1)
            else:
                self.assertEqual(self.ftp.files[path], (self.source / path).read_bytes())
        self.ftp.writes.clear()
        self.execute('deploy')
        self.assertEqual(self.ftp.writes, [])

    def test_corrupted_backup_prevents_replacements(self):
        self.ftp.corrupt_once = '.codex-backups/'
        with self.assertRaises(RuntimeError):
            self.execute('deploy')
        self.assertEqual(len(self.ftp.writes), 1)
        for path, data in self.before.items():
            self.assertEqual(self.ftp.files[path], data)

    def test_corrupted_upload_restores_old_files_and_removes_new_files(self):
        self.ftp.corrupt_once = module.FILES[3]
        with self.assertRaises(RuntimeError):
            self.execute('deploy')
        for path in module.FILES:
            self.assertEqual(self.ftp.files.get(path), self.before.get(path))

    def test_backup_can_be_decrypted_and_contains_absence_manifest(self):
        with patch.dict(os.environ, {'DEV_FTP_PASSWORD': 'test-only-password'}):
            encrypted = module.encrypted_backup({module.FILES[0]: None, module.FILES[2]: b'old source'})
            data = module.subprocess.run(
                ['openssl', 'enc', '-d', '-aes-256-cbc', '-pbkdf2', '-iter', '200000',
                 '-md', 'sha256', '-pass', 'env:DEV_FTP_PASSWORD'],
                input=encrypted, capture_output=True, check=True).stdout
        with module.tarfile.open(fileobj=io.BytesIO(data), mode='r:gz') as archive:
            manifest = json.load(archive.extractfile('manifest.json'))
            self.assertFalse(manifest[module.FILES[0]]['present'])
            self.assertEqual(archive.extractfile(module.FILES[2]).read(), b'old source')

    def test_known_dev_template_is_patched_without_overwriting_other_changes(self):
        current = self.before[module.TEMPLATE1] + b'additional current dev configuration'
        self.ftp.files[module.TEMPLATE1] = current
        with patch.object(module, 'DEV_TEMPLATE1_SHA', module.digest(current)):
            self.execute('deploy')
            deployed = self.ftp.files[module.TEMPLATE1]
            self.assertIn(b'additional current dev configuration', deployed)
            self.assertEqual(deployed.replace(
                b"        ->css('/assets/css/information-pages.css')\r\n", b'', 1), current)
            self.ftp.writes.clear()
            self.execute('deploy')
            self.assertEqual(self.ftp.writes, [])

    def test_known_hash_with_missing_anchor_is_rejected(self):
        current = b'changed layout without expected CSS chain'
        self.ftp.files[module.TEMPLATE1] = current
        with patch.object(module, 'DEV_TEMPLATE1_SHA', module.digest(current)):
            with self.assertRaises(RuntimeError):
                self.execute('deploy')
        self.assertEqual(self.ftp.writes, [])


if __name__ == '__main__':
    unittest.main()
