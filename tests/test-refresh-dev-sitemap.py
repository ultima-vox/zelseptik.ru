import importlib.util
import pathlib
import unittest

spec=importlib.util.spec_from_file_location('refresh', pathlib.Path(__file__).parents[1]/'scripts/refresh-dev-sitemap.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
INDEX=b'<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"><sitemap><loc>https://zelseptik.ru/hostcmsfiles/sitemap/part.xml</loc></sitemap></sitemapindex>'
KEEP=['https://zelseptik.ru/page-'+str(i)+'/' for i in range(332)]
BEFORE=KEEP+[KEEP[0]]+['https://zelseptik.ru'+x for x in m.OLD_PATHS]
def child(urls):return ('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'+''.join('<url><loc>'+u+'</loc></url>' for u in urls)+'</urlset>').encode()
class FTP:
 def __init__(self):self.files={'index.xml':INDEX,'part.xml':child(BEFORE)};self.renames=[]
 def cwd(self,d):assert d==m.DIRECTORY
 def nlst(self):return list(self.files)
 def retrbinary(self,cmd,cb):cb(self.files[cmd[5:]])
 def rename(self,a,b):self.files[b]=self.files.pop(a);self.renames.append((a,b))
class Cases(unittest.TestCase):
 def test_success_preserves_original(self):
  f=FTP()
  def get(p):
   if p.startswith('/sitemap.xml'):
    if 'index.xml' not in f.files:f.files['index.xml']=INDEX;f.files['part.xml']=child(KEEP)
    return INDEX
   return f.files['part.xml']
  m.refresh(f,get);self.assertEqual(len(f.renames),1);self.assertEqual(f.files[f.renames[0][1]],INDEX)
 def test_missing_index_identity_has_no_writes(self):
  f=FTP();f.files['index.xml']=b'other'
  with self.assertRaises(RuntimeError):m.refresh(f,lambda p: INDEX if p.startswith('/sitemap.xml') else child(BEFORE))
  self.assertEqual(f.renames,[])
 def test_failure_restores_missing_index(self):
  f=FTP()
  def get(p):
   if p.startswith('/sitemap.xml'):
    if 'index.xml' not in f.files:raise RuntimeError('generation failure')
    return INDEX
   return child(BEFORE)
  with self.assertRaises(RuntimeError):m.refresh(f,get)
  self.assertEqual(f.files['index.xml'],INDEX);self.assertEqual(len(f.renames),2)
 def test_concurrent_new_index_not_overwritten(self):
  f=FTP()
  def get(p):
   if p.startswith('/sitemap.xml'):
    if 'index.xml' not in f.files:f.files['index.xml']=b'concurrent';raise RuntimeError('generation failure')
    return INDEX
   return child(BEFORE)
  with self.assertRaises(RuntimeError):m.refresh(f,get)
  self.assertEqual(f.files['index.xml'],b'concurrent');self.assertEqual(len(f.renames),1)
if __name__=='__main__':unittest.main()
