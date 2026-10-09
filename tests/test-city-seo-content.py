from pathlib import Path
import importlib.util
import json
from lxml import etree, html

root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('citysql', root / 'tools/seo/generate-city-content-sql.py')
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
records = json.loads((m.CONTENT / 'manifest.json').read_text())['records']
rows = [dict(id=r['id'], shop_id=6, path=r['path'], deleted=0,
             text="Old ' text\\n", seo_title=None, seo_description='Old') for r in records]
a, b = m.generate(rows)
assert a.count('UPDATE shop_items') == b.count('UPDATE shop_items') == 5
assert 'ROLLBACK;' in a and 'ROLLBACK;' in b
assert 'COMMIT;' not in a and 'CONVERT(X\'' in a
assert 'BINARY seo_title <=> BINARY NULL' in a
assert all('BINARY '+field+' <=> BINARY ' in a for field in m.FIELDS)
for broken in [rows[:-1], rows + [rows[0]], [dict(r, shop_id=1) for r in rows], [dict(r, path='wrong') for r in rows]]:
    try: m.generate(broken)
    except ValueError: pass
    else: raise AssertionError('Invalid export accepted')
# Import the existing resolver for native HostCMS import:// templates.
spec = importlib.util.spec_from_file_location('servicecheck', root / 'tests/test-service-order-render.py')
t = importlib.util.module_from_spec(spec); spec.loader.exec_module(t)
transform = etree.XSLT(etree.fromstring(t.clean((root / 'hostcmsfiles/xsl/56.xsl').read_bytes()), t.parser))
for shop, item, value, shown in [(6,240,'<h2>City content</h2>',True),(6,233,'<h2>City content</h2>',True),(6,243,'<h2>City content</h2>',True),(6,250,'<h2>City content</h2>',True),(6,241,'<h2>City content</h2>',False),(1,240,'<h2>City content</h2>',False),(6,240,'',False)]:
    doc = etree.fromstring(f'<shop id="{shop}"><group>0</group><shop_item id="{item}"><name>Service</name><price>6000</price><text/></shop_item></shop>')
    doc.find('shop_item/text').text = value
    output = html.fromstring(str(transform(doc)))
    panel = output.xpath('//*[@data-seo-landing="city-service"]')
    assert bool(panel) == shown, (shop,item,value)
    if shown: assert len(panel[0].xpath('.//h2')) == 1
print('City SEO: native field visibility, shop/item isolation, empty fallback, guarded SQL and rollback passed.')
