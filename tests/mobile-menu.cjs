const assert=require('node:assert/strict'),fs=require('node:fs'),{JSDOM}=require('jsdom');
const source=fs.readFileSync('templates/template1/script.js','utf8');
const start=source.indexOf('  function initMobileMenu()'),end=source.indexOf('  function initSmoothNavigation()',start);
for(const reduced of [false,true]){
 const dom=new JSDOM('<button class="js-burger"></button><div class="js-mobile-drawer"><div class="mobile-drawer__dialog"><button class="js-mobile-drawer-close"></button><a href="#a">Link</a></div><div class="js-mobile-drawer-backdrop"></div></div>');
 const w=dom.window,d=w.document;let frames=new Map(),timers=new Map(),id=0,focus=[];
 w.requestAnimationFrame=fn=>{frames.set(++id,fn);return id;};w.cancelAnimationFrame=n=>frames.delete(n);w.setTimeout=fn=>{timers.set(++id,fn);return id;};w.clearTimeout=n=>timers.delete(n);w.matchMedia=()=>({matches:reduced});
 const flush=map=>{const a=[...map.values()];map.clear();a.forEach(fn=>fn());};
 for(const e of d.querySelectorAll('button')){const f=e.focus.bind(e);e.focus=opts=>{focus.push(opts);f(opts);};}
 const burger=d.querySelector('.js-burger'),drawer=d.querySelector('.js-mobile-drawer'),close=d.querySelector('.js-mobile-drawer-close');burger.focus();focus=[];d.body.style.overflow='auto';d.body.style.paddingRight='3px';
 new Function('window','document','const $=(s,c)=>(c||document).querySelector(s);const $$=(s,c)=>Array.from((c||document).querySelectorAll(s));'+source.slice(start,end)+';initMobileMenu();')(w,d);
 burger.click();assert.equal(drawer.inert,false);assert.equal(focus.length,0);flush(frames);flush(frames);assert(drawer.classList.contains('mobile-drawer--open'));flush(timers);assert.equal(d.activeElement,close);assert(focus.every(o=>o.preventScroll));
 close.click();assert.equal(d.body.style.overflow,'hidden');assert.equal(drawer.inert,true);burger.click();flush(frames);flush(frames);flush(timers);assert.equal(drawer.inert,false);
 d.dispatchEvent(new w.KeyboardEvent('keydown',{key:'Escape'}));assert.equal(d.body.style.overflow,'hidden');flush(timers);assert.equal(d.body.style.overflow,'auto');assert.equal(d.body.style.paddingRight,'3px');assert.equal(d.activeElement,burger);
 burger.click();close.click();flush(frames);flush(timers);assert(!drawer.classList.contains('mobile-drawer--open'));assert.equal(d.body.style.overflow,'auto');dom.window.close();
}
console.log('OK: staged motion, focus without scroll, delayed unlock, rapid reversal, Escape and reduced motion.');
