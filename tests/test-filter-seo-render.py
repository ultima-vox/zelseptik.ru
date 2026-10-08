"""Render matched native SEO-filter text once, without duplication on pagination."""
from pathlib import Path
import importlib.util
from lxml import etree, html
root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('catalogcheck', root/'tests/test-catalog-seo-render.py')
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
for shop, page, body, expected in [(1,0,'<h2>Filter selection</h2>',True),
        (1,1,'<h2>Filter selection</h2>',False), (6,0,'<h2>Filter selection</h2>',False),
        (1,0,'',False), (1,0,'   ',False)]:
    d = etree.fromstring(f'<shop id="{shop}"><group>0</group><page>{page}</page><url>/septiki/</url><name>Catalog</name><filter>1</filter><shop_filter_seo id="1"><h1>Native H1</h1><text/></shop_filter_seo></shop>')
    d.find('shop_filter_seo/text').text = body
    h = html.fromstring(str(m.t(d)))
    panels = h.xpath('//*[@data-seo-landing="catalog-filter"]')
    assert bool(panels) == expected, (shop,page,body)
    if expected:
        assert len(panels) == 1 and panels[0].xpath('.//h2/text()') == ['Filter selection']
        assert len(h.xpath('//h1')) == 1
    assert not h.xpath('//*[@data-seo-landing="catalog-group"]')
print('SEO-filter: native HTML once on first page; pagination, empty text and other shops excluded.')
