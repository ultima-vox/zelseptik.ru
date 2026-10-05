"""Render XSL against synthetic CMS XML; check content, grouping and form contract.
Requires lxml. Does not connect to or modify a HostCMS database.
"""
from pathlib import Path
from lxml import etree, html
ROOT = Path(__file__).resolve().parents[1]

class LocalLanguages(etree.Resolver):
    def resolve(self, url, pubid, context):
        if url.startswith('lang://'):
            return self.resolve_filename(str(ROOT / 'hostcmsfiles/xsl' / (url[7:] + '.ru.dtd')), context)


def transform(xsl_id, xml):
    parser = etree.XMLParser(load_dtd=True, resolve_entities=True, no_network=True)
    parser.resolvers.add(LocalLanguages())
    sheet = etree.XSLT(etree.parse(str(ROOT / f'hostcmsfiles/xsl/{xsl_id}.xsl'), parser))
    return html.fromstring(str(sheet(xml)))


def check():
    xml = etree.parse(str(ROOT / 'tests/fixtures/information.xml'))
    listing = transform(13, xml)
    assert len(listing.xpath('//h1')) == 1
    links = listing.xpath('//a[@class="category-bl"]/@href')
    assert links == ['/services/montazh/', '/services/servis/', '/services/podbor-septikov/'], links
    assert not listing.xpath('//span[@class="h-3_mobile"]')
    assert '/services/page-2/' in listing.xpath('//a/@href')
    detail = transform(4, xml)
    assert detail.xpath('//h1')[0].text == 'Подбор под условия участка'
    assert detail.xpath('//a[@href="/contacts/"]')
    assert 'Исходный текст CMS' in detail.text_content()
    assert detail.xpath('//img[@class="information-detail__image"]/@src') == ['/images/service.jpg']
    form = detail.xpath('//form[@data-lead-form]')[0]
    assert form.get('method') == 'post'
    assert form.xpath('.//input[@name="_zs_action"]/@value') == ['lead']
    assert form.xpath('.//input[@name="link"]/@value') == ['Подбор септика']
    assert form.xpath('.//input[@name="city_service"]')
    assert form.xpath('.//input[@name="g-recaptcha-response"]')
    assert form.xpath('.//input[@name="phone" and @required and @type="tel"]')
    assert not detail.xpath('//script')
    for label in form.xpath('.//label'):
        assert form.xpath('.//input[@id=$id]', id=label.get('for'))
    xml.find('group').text = '10'
    grouped = transform(13, xml)
    assert grouped.xpath('//h1')[0].text == 'Монтаж'
    assert grouped.xpath('//a[@class="category-bl"]/@href') == ['/services/montazh/child/', '/services/podbor-septikov/']
    detail_grouped = transform(4, xml)
    assert detail_grouped.xpath('//nav//a/@href') == ['/', '/services/', '/services/montazh/']
    item = xml.find('informationsystem_item')
    item.find('image_large').text = ''
    item.find('property_value/value').text = ''
    fallback = transform(4, xml)
    assert fallback.xpath('//h1')[0].text == 'Подбор септика'
    assert fallback.xpath('//img[@class="information-detail__image"]/@src') == ['/images/service-small.jpg']
    item.find('image_small').text = ''
    assert not transform(4, xml).xpath('//img[@class="information-detail__image"]')
    print('OK: list/group pagination, unique cards, CMS content, breadcrumbs, SEO/image fallback, lead form contract.')

if __name__ == '__main__':
    check()
