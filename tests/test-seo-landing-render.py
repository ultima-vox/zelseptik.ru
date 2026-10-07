"""Check native landing descriptions do not leak into filtered listings."""
from pathlib import Path
import re
from lxml import etree
root=Path(__file__).resolve().parents[1]/'hostcmsfiles/xsl'
def clean(b):
 s=re.sub(r'<!DOCTYPE[^>]*>','',b.decode())
 return re.sub(r'&(?!(?:amp|lt|gt|quot|apos|#\d+|#x[\da-fA-F]+);)[\w]+;', 'Translation',s).encode()
class Resolver(etree.Resolver):
 def resolve(self,url,pubid,context):
  if url.startswith('import://'):return self.resolve_string(clean((root/(url[9:]+'.xsl')).read_bytes()),context)
parser=etree.XMLParser();parser.resolvers.add(Resolver())
def render(xsl,entity,ident,extra):
 transform=etree.XSLT(etree.fromstring(clean((root/f'{xsl}.xsl').read_bytes()),parser))
 fixture=f'<{entity} id="{ident}"><name>Test</name><url>/test/</url><total>0</total><limit>12</limit><description>&lt;section data-seo-landing="test"&gt;Landing copy&lt;/section&gt;</description>{extra}</{entity}>'
 return str(transform(etree.fromstring(fixture.encode())))
for ident in [1,6]:
 assert 'Landing copy' in render(55,'shop',ident,'<group>0</group><page>0</page>')
 for extra in ['<group>1</group><page>0</page>','<group>0</group><page>1</page>','<group>0</group><page>0</page><tag/>','<group>0</group><page>0</page><shop_producer/>','<group>0</group><page>0</page><shop_filter_seo/>','<group>0</group><page>0</page><filter>1</filter>']:
  assert 'Landing copy' not in render(55,'shop',ident,extra),(ident,extra)
assert 'Landing copy' not in render(55,'shop',3,'<group>0</group><page>0</page>')
for ident in [7,8,9]:
 assert 'Landing copy' in render(3,'informationsystem',ident,'<group>0</group><page>0</page>')
 for extra in ['<group>1</group><page>0</page>','<group>0</group><page>1</page>','<group>0</group><page>0</page><tag/>']:
  assert 'Landing copy' not in render(3,'informationsystem',ident,extra),(ident,extra)
print('Native descriptions verified on root pages; absent on groups, pagination, tags, producer and SEO filters.')
