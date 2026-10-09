const fs = require('fs');
const vm = require('vm');
const assert = require('assert/strict');
const script = fs.readFileSync('templates/template1/script.js', 'utf8');
const source = script.slice(script.indexOf('function initCatalogRangeSliders()'), script.indexOf('function initExclusiveFilters()'));
class Element {
  constructor(value = '') { this.value = value; this.listeners = {}; this.attrs = {}; this.step = 'any'; }
  addEventListener(name, fn) { this.listeners[name] = fn; }
  dispatchEvent(event) { this.listeners[event.type]?.(event); }
  setAttribute(name, value) { this.attrs[name] = value; }
  setCustomValidity(message) { this.error = message; }
  focus() {}
}
function render(min = '0', max = '500', from = '', to = '') {
  const fields = [new Element(from), new Element(to)];
  const handles = [new Element(), new Element()];
  const track = new Element(); track.hidden = true;
  const selection = new Element();
  const group = { dataset: { rangeMin: min, rangeMax: max },
    querySelectorAll(selector) { return selector.includes('number') ? fields : handles; },
    querySelector(selector) { return selector === '.catalog-range' ? track : selection; }
  };
  const sandbox = { document: { querySelectorAll: () => [group] }, Event: class { constructor(type) { this.type = type; } } };
  vm.runInNewContext(source + '\ninitCatalogRangeSliders();', sandbox);
  return { fields, handles, track, selection };
}
const a = render();
assert.equal(a.track.hidden, false);
assert.deepEqual(a.fields.map(e => e.value), ['', '']); // No constraints merely from initialization.
assert.deepEqual(a.handles.map(e => e.value), ['0', '500']);
a.handles[0].value = '160'; a.handles[0].dispatchEvent({type: 'input'});
assert.deepEqual(a.fields.map(e => e.value), ['160', '']);
a.handles[1].value = '100'; a.handles[1].dispatchEvent({type: 'input'});
assert.equal(a.fields[1].value, '160'); // Crossing thumbs cannot reverse the range.
a.fields[0].value = '200'; a.fields[0].dispatchEvent({type: 'input'});
assert.ok(a.fields[1].error); // Reversed manual values prevent native submit.
a.fields[1].value = ''; a.fields[1].dispatchEvent({type: 'input'});
assert.equal(a.fields[1].error, '');
assert.equal(a.handles[1].value, '500');
const b = render('50', '500', '10', '900');
assert.deepEqual(b.fields.map(e => e.value), ['10', '900']);
assert.equal(b.handles[0].min, '10'); assert.equal(b.handles[1].max, '900');
assert.equal(render('', '').track.hidden, true);
assert.equal(render('500', '500').track.hidden, true);
console.log('Catalog sliders: unrestricted initialization, native numeric sync, crossing, manual validation, GET restoration and missing bounds verified.');
