"""Check native variant URLs, deduplication, current state and empty/service cases."""
from pathlib import Path
from lxml import etree, html
import runpy
helpers = runpy.run_path(str(Path(__file__).with_name('test-service-order-render.py')))
transform = etree.XSLT(etree.fromstring(helpers['clean']((helpers['root']/'56.xsl').read_bytes()), helpers['parser']))
def render(shop=1, variants=True):
    links = '''<associated><shop_item id="2"><name>Other</name><url>/other/</url></shop_item><shop_item id="1"><name>Current</name><url>/current/</url></shop_item></associated><modifications><shop_item id="2"><name>Duplicate</name><url>/other/</url></shop_item><shop_item id="3"><name>Third</name><url>/third/</url></shop_item></modifications>''' if variants else ''
    return html.fromstring(str(transform(etree.fromstring(f'<shop id="{shop}"><group>0</group><shop_currency><code>RUB</code></shop_currency><shop_item id="1"><name>Current</name><url>/current/</url><price>100</price><discount>0</discount><description>Text</description>{links}</shop_item></shop>'.encode()))))
doc=render();links=doc.xpath('//nav[@class="product-variants"]//a')
assert [a.get('href') for a in links] == ['/current/', '/other/', '/third/']
assert len(doc.xpath('//nav[@class="product-variants"]//a[@aria-current="page"]')) == 1
assert doc.xpath('//div[@class="product-description"]/article')
assert not doc.xpath('//*[contains(@class,"nav-pills")]')
assert doc.xpath('//div[@class="catalog-card__body"]/nav/following-sibling::div[@class="catalog-card__actions"]')
for shop, variants in [(6,True),(1,False)]:
    assert not render(shop,variants).xpath('//nav[@class="product-variants"]')
print('Native product variants: deduplication, links, placement, services and empty states passed')
