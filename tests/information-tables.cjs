// Run with Node and jsdom installed; no browser, requests or live form submissions.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { JSDOM } = require('jsdom');

const source = fs.readFileSync(path.join(__dirname, '../assets/js/modules/information.js'), 'utf8');
const fixture = `<div class="information-detail"><div class="tbl-wrap"><h2>Стоимость работ</h2><div class="tbl-row">
<div class="tbl"><table><thead><tr><td>Услуга</td></tr></thead><tbody>
<tr><td><a id="installation" href="/services/install/">Монтаж</a></td></tr><tr><td>Обслуживание</td></tr>
</tbody></table></div><div class="swiper-box"><div class="swiper-wrapper">
<div class="swiper-slide"><div class="sw-tbl-head">Цена</div><div class="sw-tbl-body"><div class="sw-tr">24 000 ₽</div><div class="sw-tr">5 000 ₽</div></div></div>
<div class="swiper-slide"><div class="sw-tbl-head">Выезд</div><div class="sw-tbl-body"><div class="sw-tr">Бесплатно</div><div class="sw-tr">По согласованию</div></div></div>
</div></div></div></div></div>`;
(async () => {
  const { initInformationTables } = await import('data:text/javascript;base64,' + Buffer.from(source).toString('base64'));
  const dom = new JSDOM(fixture);
  global.document = dom.window.document;
  initInformationTables();
  const container = document.querySelector('.tbl-row');
  const table = container.querySelector('table');
  const values = [...table.rows].map((row) => [...row.cells].map((cell) => cell.textContent.trim()));
  assert.deepEqual(values, [['Услуга', 'Цена', 'Выезд'], ['Монтаж', '24 000 ₽', 'Бесплатно'], ['Обслуживание', '5 000 ₽', 'По согласованию']]);
  assert.equal(document.querySelectorAll('#installation').length, 1);
  assert.equal(document.querySelector('#installation').getAttribute('href'), '/services/install/');
  assert.equal(table.tHead.rows[0].cells[0].scope, 'col');
  assert.equal(table.tBodies[0].rows[0].cells[0].scope, 'row');
  assert.equal(container.getAttribute('aria-label'), 'Стоимость работ');
  assert.equal(container.tabIndex, 0);
  assert.equal(container.querySelector('.swiper-box'), null);
  const enhanced = container.outerHTML;
  initInformationTables();
  assert.equal(container.outerHTML, enhanced, 'Repeated initialization must not duplicate cells');
  for (const change of [
    (doc) => doc.querySelector('.sw-tr').remove(),
    (doc) => doc.querySelector('tbody td').setAttribute('rowspan', '2'),
    (doc) => doc.querySelector('.sw-tbl-head').remove(),
    (doc) => doc.querySelector('table').appendChild(doc.createElement('tbody')),
    (doc) => doc.querySelector('.tbl').appendChild(doc.querySelector('table').cloneNode(true)),
  ]) {
    const broken = new JSDOM(fixture);
    global.document = broken.window.document;
    change(document);
    const original = document.body.innerHTML;
    initInformationTables();
    assert.equal(document.body.innerHTML, original, 'Inconsistent CMS columns must stay intact');
  }
  const unrelated = new JSDOM(fixture.replace('information-detail', 'approved-page'));
  global.document = unrelated.window.document;
  const original = document.body.innerHTML;
  initInformationTables();
  assert.equal(document.body.innerHTML, original, 'Approved pages must stay intact');
  console.log('OK: prices align with services; links/IDs preserved; semantic headers, idempotence, invalid-column fallback and scope isolation.');
})();
