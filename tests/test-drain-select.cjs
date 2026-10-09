const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const source = fs.readFileSync('templates/template1/script.js', 'utf8');
const start = source.indexOf('function initExclusiveFilters()');
const end = source.indexOf('function initRangeFilters()', start);
for (const search of ['', '?property_2=1', '?property_3=1']) {
  const inputs = ['property_3','property_2'].map(name => ({name,disabled:true,dataset:{exclusiveFilterInput:name}}));
  const listeners = {};
  const select = {value:'',addEventListener:(event,fn)=>{listeners[event]=fn;}};
  const group = {querySelectorAll:selector=>selector==='[data-exclusive-filter-input]'?inputs:[],querySelector:()=>select};
  const context = {URLSearchParams,window:{location:{search}},document:{querySelectorAll:()=>[group]}};
  vm.runInNewContext(source.slice(start,end)+';initExclusiveFilters();',context);
  const expected = new URLSearchParams(search).has('property_2') ? 'property_2' : new URLSearchParams(search).has('property_3') ? 'property_3' : '';
  assert.equal(select.value,expected);
  for (const choice of ['property_2','property_3','']) {
    select.value=choice;listeners.change();
    assert.deepEqual(inputs.filter(input=>!input.disabled).map(input=>input.name),choice?[choice]:[]);
  }
}
console.log('Drain dropdown restores the current parameter and submits exactly one existing HostCMS property, or none.');
