// Verify navigation against HTML rendered from the actual HostCMS XSL.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');
const { JSDOM } = require('jsdom');
const root = path.join(__dirname, '..');
const fixture = execFileSync('python', ['-c', `
import importlib.util
from lxml import etree
s=importlib.util.spec_from_file_location('checks','scripts/check-information-ui.py')
m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
xml=etree.ElementTree(etree.fromstring(b'<shop id="1"><url>/septiki/</url><group>0</group><total>0</total><limit>20</limit><page>0</page></shop>'))
print(etree.tostring(m.transform(282,xml),encoding='unicode',method='html'))
`], { cwd: root, encoding: 'utf8' });

(async () => {
  const source = fs.readFileSync(path.join(root, 'assets/js/modules/information.js'), 'utf8');
  const { initInformationQuiz, initInformationPages } = await import('data:text/javascript;base64,' + Buffer.from(source).toString('base64'));
  const dom = new JSDOM(fixture, { url: 'https://dev.zelseptik.ru/services/podbor-septikov/' });
  global.document = dom.window.document;
  initInformationQuiz();
  const form = document.querySelector('.form-quiz');
  const slides = [...form.querySelectorAll('.swiper-wrapper > .swiper-slide')];
  const active = () => slides.filter((slide) => !slide.hidden);
  assert.equal(active().length, 1);
  assert.equal(active()[0], slides[0]);
  assert.equal(form.querySelectorAll('.quiz-form input:not(:disabled)').length, 0);
  active()[0].querySelector('button.next').click();
  assert.equal(active()[0], slides[0], 'Cannot skip an unanswered question');
  assert.equal(form.lastElementChild.hidden, false);
  active()[0].querySelector('input').checked = true;
  active()[0].querySelector('button.next').click();
  assert.equal(active()[0], slides[1]);
  active()[0].querySelector('button.prev').click();
  assert.equal(active()[0].querySelector('input').checked, true, 'Back preserves the answer');
  for (let index = 0; index < 5; index++) {
    active()[0].querySelector('.quiz-chk input').checked = true;
    active()[0].querySelector('button.next').click();
  }
  assert.equal(active()[0], slides[5]);
  assert.equal(form.querySelectorAll('input[name="name"]:not(:disabled)').length, 1);
  assert.equal(form.querySelectorAll('input[name="phone"]:not(:disabled)').length, 1);
  assert.equal(new dom.window.FormData(form).getAll('name').length, 1);
  assert.equal(new dom.window.FormData(form).get('count'), '1-6');
  const state = form.outerHTML;
  initInformationQuiz();
  assert.equal(form.outerHTML, state, 'Initialization is idempotent');
  document.querySelector('.clicked_question[data-key="3"]').click();
  assert.equal(active()[0], slides[6]);
  assert.equal(new dom.window.FormData(form).getAll('name').length, 1);
  active()[0].querySelector('button.prev').click();
  assert.equal(active()[0], slides[0]);
  const ctaDom = new JSDOM('<main><section class="cta-section"><h2 class="cta-section__title">Септик</h2><p class="cta-section__desc"></p><span class="cta-section__gift-name"></span><form method="post"><input name="phone"><button type="submit">Септик</button></form></section></main>', { url: 'https://dev.zelseptik.ru/pogreba/' });
  initInformationPages(ctaDom.window.document);
  assert.match(ctaDom.window.document.querySelector('h2').textContent, /погреб/);
  assert.equal(ctaDom.window.document.querySelector('form').getAttribute('method'), 'post');
  console.log('OK: real quiz XSL, answer validation, back, multi-step navigation, one contact set, consultation branch, idempotence and contextual CTA. No live submissions.');
})();
