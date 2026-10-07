from pathlib import Path
import re
from lxml import etree,html
root=Path(__file__).resolve().parents[1]/'hostcmsfiles/xsl'
def clean(b):
 s=b.decode();s=re.sub(r'<!DOCTYPE[^>]*>','',s)
 s=re.sub(r'&(?!(?:amp|lt|gt|quot|apos|#\d+|#x[\da-fA-F]+);)[\w]+;', 'Translation',s)
 return s.encode()
class Resolver(etree.Resolver):
 def resolve(self,url,pubid,context):
  if url.startswith('import://'):return self.resolve_string(clean((root/(url[9:]+'.xsl')).read_bytes()),context)
parser=etree.XMLParser();parser.resolvers.add(Resolver())
for i in [55,56,176,278]:
 tree=etree.fromstring(clean((root/(str(i)+'.xsl')).read_bytes()),parser)
 if i==176:
  template=etree.SubElement(tree,'{http://www.w3.org/1999/XSL/Transform}template',match='/')
  etree.SubElement(template,'{http://www.w3.org/1999/XSL/Transform}apply-templates',select='/shop/shop_item')
 transform=etree.XSLT(tree)
 for shop in [1,6]:
  fixture=f'''<shop id="{shop}"><name>Test</name><url>/test/</url><group>0</group><total>1</total><limit>12</limit><shop_currency><code>RUB</code></shop_currency><shop_item id="240"><name>Test service</name><url>/test/item/</url><dir>/upload/shop_{shop}/item/</dir><image_large>photo.jpg</image_large><image_small>thumb.jpg</image_small><price>6000</price><discount>0</discount><description>Test</description></shop_item></shop>'''
  result=html.fromstring(str(transform(etree.fromstring(fixture.encode()))))
  buttons=result.cssselect('.js-catalog-order') if False else result.xpath('//button[contains(@class,"js-catalog-order")]')
  assert buttons,(i,shop,'No trigger')
  if i!=56:
   specs=result.xpath('//*[contains(concat(" ",normalize-space(@class)," ")," catalog-card__specs ")]')
   assert bool(specs)==(shop!=6),(i,shop,'equipment specifications visibility')
  assert all(b.get('data-order-kind')==('service' if shop==6 else 'installation') for b in buttons)
  if i!=56:assert all(('Заказать обслуживание' if shop==6 else 'Заказать монтаж') in b.text_content() for b in buttons)
  if i==56:
   gallery=result.xpath('//*[contains(@class,"hero-section")]//*[@data-fancybox]')
   assert bool(gallery)==(shop!=6),(shop,'gallery mismatch')
 print(i,'service / installation contexts verified')
