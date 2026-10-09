const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const source = fs.readFileSync('templates/template1/script.js', 'utf8');
const code = source.slice(source.indexOf('function initAjaxForms()'), source.indexOf('function initGiftsSelector()'));
function form(method, marker, names) {
  return {method, marker, elements: names.map(name => ({name})), listeners: [],
    querySelector(selector) { return selector === 'input[name="phone"]' && names.includes('phone') ? {} : null; },
    addEventListener(event, callback) { if (event === 'submit') this.listeners.push(callback); }};
}
const forms = [
  form('get', 'data-lead-form', ['filter', 'phone']),
  form('post', 'data-lead-form', ['filter', 'phone']),
  form('post', 'js-modal-form', ['property_6_from', 'phone']),
  form('post', 'data-ajax-form', ['phone']),
  form('post', 'data-lead-form', ['phone', 'form_type']),
  form('post', 'js-cta-form', ['phone']),
  form('post', 'js-modal-form', ['phone']),
  form('post', 'data-lead-form', ['message']),
];
const context = {window: {grecaptcha: {ready() {}}}, console,
  document: {querySelectorAll(selector) {return forms.filter(f => selector.includes(f.marker));}}};
vm.createContext(context);
context.grecaptcha = context.window.grecaptcha;
vm.runInContext(code + '\ninitAjaxForms();', context);
assert.deepEqual(forms.map(f => f.listeners.length), [0,0,0,0,1,1,1,0]);
console.log('Only POST contact/lead forms get the email handler; GET, catalog controls and generic AJAX forms keep native submission.');
