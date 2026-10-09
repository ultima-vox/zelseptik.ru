"""Reject partial/wrong target exports and keep every migration reversible by default."""
from pathlib import Path
import json,importlib.util,copy
root=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('catalogsql',root/'tools/seo/generate-catalog-content-sql.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
archive=root/'docs/archive/seo-catalog-before-2026-10-08'
groups=[dict(r,shop_id=1,deleted=0) for r in json.loads((archive/'group-fields.json').read_text())]
shop=json.loads((archive/'root-fields.json').read_text());shop.update({r['name']:r['value'] for r in json.loads((archive/'shop-seo-templates.json').read_text()) if r['name'] in m.SHOP_FIELDS});shop.update(id=1,deleted=0)
structure=dict(json.loads((archive/'structure-5.json').read_text()),deleted=0)
export={'groups':groups,'shop':shop,'structure':structure};apply,reverse=m.generate(export)
assert apply.count('UPDATE ')==reverse.count('UPDATE ')==15
assert all(s.rstrip().endswith('ROLLBACK;') and '\nCOMMIT;' not in s for s in (apply,reverse))
assert 'BINARY path = BINARY ' in apply and 'BINARY seo_title <=> BINARY ' in apply
for mutation in ['missing','duplicate','wrong_shop','wrong_path','deleted','wrong_structure','wrong_root']:
 bad=copy.deepcopy(export)
 if mutation=='missing':bad['groups'].pop()
 if mutation=='duplicate':bad['groups'].append(bad['groups'][0])
 if mutation=='wrong_shop':bad['groups'][0]['shop_id']=6
 if mutation=='wrong_path':bad['groups'][0]['path']='other'
 if mutation=='deleted':bad['groups'][0]['deleted']=1
 if mutation=='wrong_structure':bad['structure']['id']=25
 if mutation=='wrong_root':bad['shop']['id']=6
 try:m.generate(bad)
 except ValueError:pass
 else:raise AssertionError(mutation+' accepted')
quoted=copy.deepcopy(export);quoted['groups'][0]['seo_title']="O'Reilly \\ test\n";quoted['groups'][0]['seo_description']=None
q,_=m.generate(quoted);assert 'BINARY seo_description <=> BINARY NULL' in q;assert "O'Reilly" not in q
print('Catalog SQL: 15 guarded updates, rollback default, reverse migration, exact identities, NULL and quote handling passed.')
