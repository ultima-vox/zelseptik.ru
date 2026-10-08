"""Render native GET fields and preserve submitted ranges without lead fields."""
from pathlib import Path
import importlib.util
from lxml import etree, html
root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('catalogcheck', root / 'tests/test-catalog-seo-render.py')
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
for shop, url, expected in [(1, '/septiki/', True), (6, '/obsluzhivanie-po-gorodam/', False)]:
    d = etree.fromstring(f'''<shop id="{shop}"><group>0</group><url>{url}</url><name>Catalog</name><filter>1</filter><price_from>90000</price_from><price_to>200000</price_to><property_4_from>750</property_4_from><property_4_to>1500</property_4_to><property_5_from>160</property_5_from><property_5_to>300</property_5_to><property_2>1</property_2><shop_item_properties><property id="4"><name>Производительность</name><filter>6</filter></property><property id="5"><name>Залповый сброс</name><filter>6</filter></property><property id="2"><name>Принудительный</name></property><property id="3"><name>Самотечный</name></property></shop_item_properties></shop>''')
    h = html.fromstring(str(m.t(d)))
    panels = h.xpath('//*[@class="catalog-filter"]')
    assert bool(panels) == expected
    if not expected:
        continue
    panel = panels[0]
    for name, value in {'price_from': '90000', 'price_to': '200000', 'property_4_from': '750', 'property_4_to': '1500', 'property_5_from': '160', 'property_5_to': '300'}.items():
        fields = panel.xpath(f'.//input[@name="{name}"]')
        assert len(fields) == 1 and fields[0].get('value') == value, (name, value)
        assert fields[0].get('type') == 'number' and fields[0].get('aria-label')
    assert panel.xpath('.//input[@name="property_2" and not(@disabled)]')
    assert panel.xpath('.//input[@name="property_3" and @disabled]')
    assert panel.xpath('ancestor::form[1]')[0].get('method') == 'get'
    assert not panel.xpath('.//input[@name="phone" or @name="_zs_action"]')
print('Native filter: numeric ranges round-trip; existing drain properties; GET only; other shop excluded.')
