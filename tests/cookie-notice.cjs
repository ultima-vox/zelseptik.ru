const assert=require('node:assert/strict'), fs=require('node:fs'),{JSDOM}=require('jsdom');
const source=fs.readFileSync('templates/template1/script.js','utf8').split('// Dismiss the notice without recording cookie consent.')[1];
function run(stored,blocked){
 const dom=new JSDOM('<div class="alert-fz"><p>Исходное уведомление <a href="/policy/">Подробнее</a></p></div>',{url:'https://dev.zelseptik.ru',runScripts:'outside-only'}),w=dom.window,d=w.document;
 if(stored)w.localStorage.setItem('zelseptik:cookie-notice-dismissed:v1','1');
 if(blocked)Object.defineProperty(w,'localStorage',{get(){throw Error('Blocked');}});
 w.eval(source);d.dispatchEvent(new w.Event('DOMContentLoaded'));
 const n=d.querySelector('.alert-fz');
 if(stored)assert.equal(n.hidden,true);
 else{const b=n.querySelector('button');assert.equal(b.type,'button');assert.equal(b.getAttribute('aria-label'),'Закрыть уведомление о cookie');assert.equal(n.querySelector('p').textContent,'Исходное уведомление Подробнее');b.click();assert.equal(n.hidden,true);if(!blocked)assert.equal(w.localStorage.getItem('zelseptik:cookie-notice-dismissed:v1'),'1');}
 w.eval(source);d.dispatchEvent(new w.Event('DOMContentLoaded'));assert.ok(n.querySelectorAll('button').length<=1);dom.window.close();
}
run(false,false);run(true,false);run(false,true);console.log('OK: close button, persistent dismissal, blocked-storage fallback, text/link preservation and idempotence.');
