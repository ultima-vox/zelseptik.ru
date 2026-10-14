"""Prepare catalog migration and reverse SQL from a fresh, reviewed database export.

Never connects to a database. Both scripts end in ROLLBACK by default.
"""
import argparse
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
CONTENT=ROOT/'docs/seo-content/catalog-2026-10-08'
GROUP_FIELDS=('description','seo_title','seo_description')
STRUCTURE_FIELDS=('seo_title','seo_description')
SHOP_FIELDS=('description','seo_root_title_template','seo_root_description_template')

def literal(value):
    if value is None:return 'NULL'
    if not isinstance(value,str):raise ValueError('Expected string or null')
    return "CONVERT(X'%s' USING utf8mb4)" % value.encode('utf-8').hex()

def statement(table,row,fields,before,after):
    guard=[f"id = {row['id']}",'deleted = 0']
    if table=='shop_groups':guard.append('shop_id = 1')
    if table in ('shop_groups','structures'):guard.append('BINARY path = BINARY '+literal(row['path']))
    guard.extend('BINARY '+f+' <=> BINARY '+literal(before[f]) for f in fields)
    return 'UPDATE '+table+' SET '+', '.join(f+' = '+literal(after[f]) for f in fields)+' WHERE '+' AND '.join(guard)+';\nSELECT ROW_COUNT() AS changed_rows;'

def generate(export):
    if not isinstance(export,dict) or set(export)!={'groups','shop','structure'}:raise ValueError('Expected groups, shop and structure')
    groups=export['groups'];shop=export['shop']
    if not isinstance(groups,list) or not all(isinstance(r,dict) for r in groups):raise ValueError('Invalid groups')
    if not all(type(r.get('id')) is int for r in groups):raise ValueError('IDs must be integers')
    if len({r['id'] for r in groups})!=len(groups):raise ValueError('Duplicate IDs')
    rows={r['id']:r for r in groups};records=json.loads((CONTENT/'manifest.json').read_text())
    if set(rows)!={r['id'] for r in records}:raise ValueError('Expected exactly 13 reviewed categories')
    apply=[];reverse=[]
    for record in records:
        row=rows[record['id']]
        if row.get('shop_id')!=1 or row.get('deleted')!=0 or row.get('path')!=record['slug']:raise ValueError('Category identity differs')
        before={f:row[f] for f in GROUP_FIELDS}
        after={'description':(CONTENT/record['file']).read_text(),'seo_title':record['title'],'seo_description':record['description']}
        apply.append(statement('shop_groups',row,GROUP_FIELDS,before,after));reverse.append(statement('shop_groups',row,GROUP_FIELDS,after,before))
    if not isinstance(shop,dict) or type(shop.get('id')) is not int or shop['id']!=1 or shop.get('deleted')!=0:raise ValueError('Wrong shop')
    before={f:shop[f] for f in SHOP_FIELDS};after=json.loads((CONTENT/'root-seo.json').read_text());after['description']=(CONTENT/'root.html').read_text()
    apply.append(statement('shops',shop,SHOP_FIELDS,before,after));reverse.append(statement('shops',shop,SHOP_FIELDS,after,before))
    structure=export['structure'];record=json.loads((CONTENT/'structure-seo.json').read_text())
    if not isinstance(structure,dict) or type(structure.get('id')) is not int or structure['id']!=record['id'] or structure.get('path')!=record['path'] or structure.get('deleted')!=0:raise ValueError('Wrong catalog structure')
    before={f:structure[f] for f in STRUCTURE_FIELDS};after={f:record[f] for f in STRUCTURE_FIELDS}
    apply.append(statement('structures',structure,STRUCTURE_FIELDS,before,after));reverse.append(statement('structures',structure,STRUCTURE_FIELDS,after,before))
    prefix='-- Catalog SEO migration. Use only with a fresh export from the target database.\n-- Confirm all 15 changed_rows values are 1 before choosing COMMIT.\nSET NAMES utf8mb4;\nSTART TRANSACTION;\n'
    suffix='\n-- Deliberate dry run; review every result before committing.\nROLLBACK;\n'
    return prefix+'\n'.join(apply)+suffix,prefix+'\n'.join(reverse)+suffix

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--export',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    apply,reverse=generate(json.loads(a.export.read_text()));a.output.mkdir(parents=True,exist_ok=True)
    (a.output/'apply.sql').write_text(apply);(a.output/'rollback.sql').write_text(reverse)
    print('Prepared two scripts; neither was executed.')
