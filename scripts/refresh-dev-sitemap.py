"""Refresh only the generated sitemap index on isolated dev; preserve old cache."""
import collections
import ftplib
import io
import json
import os
import re
import urllib.parse
import urllib.request
import uuid
import xml.etree.ElementTree as ET

ORIGIN = 'https://dev.zelseptik.ru'
DIRECTORY = '/hostcmsfiles/sitemap'
NS = '{http://www.sitemaps.org/schemas/sitemap/0.9}'
OLD_PATHS = {
    '/obsluzhivanie-po-gorodam/servisnoe-obsluzhivanie-septikov-v-istre/',
    '/obsluzhivanie-po-gorodam/servisnoe-obsluzhivanie-septikov-v-krasnogorske/',
    '/obsluzhivanie-po-gorodam/servisnoe-obsluzhivanie-septikov-v-zelenograde/',
}


def fetch(path):
    with urllib.request.urlopen(ORIGIN + path, timeout=45) as response:
        if response.status != 200:
            raise RuntimeError('Unexpected dev response status')
        return response.read()


def read(ftp, name):
    result = io.BytesIO()
    def collect(data):
        if result.tell() + len(data) > 4000000:
            raise RuntimeError('Sitemap cache exceeds size limit')
        result.write(data)
    ftp.retrbinary('RETR ' + name, collect)
    return result.getvalue()


def nodes(xml, get):
    root = ET.fromstring(xml)
    if root.tag != NS + 'sitemapindex':
        raise RuntimeError('Expected sitemap index')
    children = root.findall(NS + 'sitemap/' + NS + 'loc')
    if not 1 <= len(children) <= 20:
        raise RuntimeError('Unexpected sitemap child count')
    result = []
    for child in children:
        url = urllib.parse.urlsplit(child.text)
        if url.scheme != 'https' or url.netloc not in ('zelseptik.ru', 'dev.zelseptik.ru') or not url.path.startswith(DIRECTORY + '/') or url.query or url.fragment:
            raise RuntimeError('Unexpected sitemap child location')
        tree = ET.fromstring(get(url.path))
        if tree.tag != NS + 'urlset':
            raise RuntimeError('Expected child urlset')
        result.extend(x.text for x in tree.findall(NS + 'url/' + NS + 'loc'))
    return result


def refresh(ftp, get=fetch):
    before_xml = get('/sitemap.xml')
    before = nodes(before_xml, get)
    expected = {u for u in before if urllib.parse.urlsplit(u).path not in OLD_PATHS}
    if len(expected) != 332:
        raise RuntimeError('Current sitemap differs from reviewed URL set; no writes')
    ftp.cwd(DIRECTORY)
    names = {n.rsplit('/', 1)[-1] for n in ftp.nlst()}
    candidates = [n for n in names if n.endswith('.xml') and '/' not in n and n not in ('.', '..')]
    if len(candidates) > 20:
        raise RuntimeError('Unexpected sitemap inventory; no writes')
    matching = [n for n in candidates if read(ftp, n) == before_xml]
    if len(matching) != 1:
        raise RuntimeError('Cannot identify exact cached index; no writes')
    name = matching[0]
    if read(ftp, name) != before_xml:
        raise RuntimeError('Concurrent index change; no writes')
    backup = name + '.before-city-refresh-' + uuid.uuid4().hex + '.bak'
    ftp.rename(name, backup)
    try:
        after = nodes(get('/sitemap.xml?refresh=city-20261007'), get)
        repeated = nodes(get('/sitemap.xml'), get)
        if set(after) != expected or after != repeated or len(after) != len(expected):
            raise RuntimeError('Refreshed sitemap differs from reviewed URL set')
        if any('/tag/' in u for u in after):
            raise RuntimeError('Tags returned to sitemap')
        print(json.dumps({'entries_before':len(before), 'entries_after':len(after),
                          'unique_after':len(set(after)), 'duplicates_after':sum(n-1 for n in collections.Counter(after).values()),
                          'strict_xml_valid':True, 'repeated_response_verified':True,
                          'old_index_backup':DIRECTORY + '/' + backup}))
    except BaseException:
        ftp.cwd(DIRECTORY)
        current = {n.rsplit('/', 1)[-1] for n in ftp.nlst()}
        if name not in current:
            ftp.rename(backup, name)
            print('Original index restored after failed refresh')
        else:
            print('Generated index retained; original backup preserved; verification failed')
        raise


def main():
    page = fetch('/').decode('utf-8')
    if not re.search(r'name=[\"\']robots[\"\'][^>]+content=[\"\']noindex, nofollow', page):
        raise RuntimeError('Dev indexing protection not confirmed; no writes')
    ftp = ftplib.FTP(timeout=45)
    try:
        ftp.connect('92.63.102.79', 21)
        ftp.login('zelseptik', os.environ['DEV_FTP_PASSWORD'])
        ftp.set_pasv(True)
        refresh(ftp)
        ftp.quit()
    finally:
        ftp.close()


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print('Stopped:', type(error).__name__)
        raise SystemExit(1)
