import contextlib, importlib.util, io, json, tempfile, unittest
from pathlib import Path
from unittest.mock import patch
spec=importlib.util.spec_from_file_location('deployment',Path(__file__).with_name('deploy-dev-seo.py'))
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
class FTP:
    def __init__(self,files):self.files=dict(files);self.directory='';self.writes=[];self.corrupt=None
    def cwd(self,path):self.directory=path.strip('/')
    def nlst(self):
        prefix=self.directory+'/' if self.directory else ''
        return sorted({p[len(prefix):].split('/')[0] for p in self.files if p.startswith(prefix)})
    def mkd(self,name):pass
    def retrbinary(self,command,collect):collect(self.files[self.directory+'/'+command[5:]])
    def storbinary(self,command,source):
        path=self.directory+'/'+command[5:];data=source.read();self.writes.append(path)
        if self.corrupt==path:data=b'corrupt';self.corrupt=None
        self.files[path]=data
    def delete(self,name):del self.files[self.directory+'/'+name]
class Tests(unittest.TestCase):
    def setUp(self):
        t=tempfile.TemporaryDirectory();self.addCleanup(t.cleanup);self.source=Path(t.name);self.before={}
        for p in m.FILES:
            f=self.source/p;f.parent.mkdir(parents=True,exist_ok=True);f.write_bytes(('new '+p).encode());self.before[p]=('old '+p).encode()
        (self.source/'docs').mkdir();(self.source/'docs/seo-originals.json').write_text(json.dumps({'files':[{'path':p,'sha256':m.digest(d)} for p,d in self.before.items()]}))
        self.ftp=FTP(self.before)
    def run_deploy(self,mode='deploy',qa_error=None):
        with contextlib.redirect_stdout(io.StringIO()),patch.object(m,'encrypted_backup',return_value=b'encrypted'),patch.object(m,'sitemap_nodes',return_value={'url'}),patch.object(m,'verify_dev',side_effect=qa_error):m.deploy(self.ftp,self.source,mode)
    def test_inspect_read_only(self):self.run_deploy('inspect');self.assertEqual(self.ftp.writes,[])
    def test_drift_stops_before_backup(self):
        self.ftp.files[m.FILES[0]]=b'unknown'
        with self.assertRaises(RuntimeError):self.run_deploy()
        self.assertEqual(self.ftp.writes,[])
    def test_success_and_backup_first(self):
        self.run_deploy();self.assertTrue(self.ftp.writes[0].startswith(m.BACKUP_DIRECTORY+'/'))
        for p in m.FILES:self.assertEqual(self.ftp.files[p],(self.source/p).read_bytes())
    def test_corrupt_upload_rolls_back(self):
        self.ftp.corrupt=m.FILES[-1]
        with self.assertRaises(RuntimeError):self.run_deploy()
        for p in m.FILES:self.assertEqual(self.ftp.files[p],self.before[p])
    def test_public_qa_failure_rolls_back(self):
        with self.assertRaises(RuntimeError):self.run_deploy(qa_error=RuntimeError('bad XML'))
        for p in m.FILES:self.assertEqual(self.ftp.files[p],self.before[p])
    def test_external_sitemap_child_rejected(self):
        xml=b'<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"><sitemap><loc>https://example.org/file.xml</loc></sitemap></sitemapindex>'
        with patch.object(m,'fetch_dev',return_value=xml),self.assertRaises(RuntimeError):m.sitemap_nodes(True)
    def test_corrupt_child_xml_rejected(self):
        xml=b'<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"><sitemap><loc>https://zelseptik.ru/hostcmsfiles/sitemap/one.xml</loc></sitemap></sitemapindex>'
        with patch.object(m,'fetch_dev',side_effect=[xml,b'<urlset>broken']):
            with self.assertRaises(Exception):m.sitemap_nodes(True)
if __name__=='__main__':unittest.main()
