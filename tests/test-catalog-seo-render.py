"""Native group descriptions must not leak onto filters, pagination or other shops."""
from pathlib import Path
import importlib.util
from lxml import etree,html
root=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('servicecheck',root/'tests/test-service-order-render.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
t=etree.XSLT(etree.fromstring(m.clean((root/'hostcmsfiles/xsl/55.xsl').read_bytes()),m.parser))
for shop,group,page,extra,body,expected in [(1,10,0,'','<h2>Native group text</h2>',True),(1,10,1,'','<h2>Native group text</h2>',False),(1,0,0,'','<h2>Native group text</h2>',False),(6,10,0,'','<h2>Native group text</h2>',False),(1,10,0,'<shop_filter_seo id="4"><h1>Filter</h1></shop_filter_seo>','<h2>Native group text</h2>',False),(1,10,0,'<filter>1</filter>','<h2>Native group text</h2>',False),(1,10,0,'<tag><name>Tag</name></tag>','<h2>Native group text</h2>',False),(1,10,0,'','',False)]:
 d=etree.fromstring(f'<shop id="{shop}"><group>{group}</group><page>{page}</page><url>/septiki/</url><name>Catalog</name>{extra}<shop_group id="10"><name>Topas</name><description/></shop_group><catalog_groups><shop_group id="10"><name>Topas</name><description/></shop_group></catalog_groups></shop>')
 for desc in d.xpath('.//shop_group/description'):desc.text=body
 h=html.fromstring(str(t(d))); panels=h.xpath('//*[@data-seo-landing="catalog-group"]');assert bool(panels)==expected,(shop,group,page,extra)
 if expected:assert len(panels)==1 and len(panels[0].xpath('.//h2'))==1
print('Catalog SEO: native HTML renders once; filters, pagination, root, other shops and empty text excluded.')
