"""Generate guarded product SEO apply/rollback SQL from a fresh target export.

Does not connect to MySQL. Both outputs deliberately end in ROLLBACK.
Product properties must be transferred separately through existing HostCMS fields.
"""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CONTENT = ROOT / 'docs/seo-content/products-topas-2026-10-08'
FIELDS = ('description', 'seo_title', 'seo_description', 'seo_keywords')


def literal(value):
    if value is None:
        return 'NULL'
    if not isinstance(value, str):
        raise ValueError('Text field must be a string or null')
    return "CONVERT(X'%s' USING utf8mb4)" % value.encode('utf-8').hex()


def statement(row, before, after):
    guard = [f"id = {row['id']}", 'shop_id = 1', 'shop_group_id = 10',
             'deleted = 0', 'BINARY path = BINARY ' + literal(row['path'])]
    guard.extend('BINARY ' + field + ' <=> BINARY ' + literal(before[field])
                 for field in FIELDS)
    return ('UPDATE shop_items SET ' + ', '.join(
        field + ' = ' + literal(after[field]) for field in FIELDS)
        + ' WHERE ' + ' AND '.join(guard)
        + ';\nSELECT ROW_COUNT() AS changed_rows;')


def generate(export):
    records = json.loads((CONTENT / 'manifest.json').read_text())
    if not isinstance(export, list) or not all(isinstance(r, dict) for r in export):
        raise ValueError('Expected a list of fresh shop_items records')
    if not all(type(r.get('id')) is int for r in export):
        raise ValueError('IDs must be integers')
    rows = {r['id']: r for r in export}
    if len(rows) != len(export):
        raise ValueError('Duplicate IDs')
    if set(rows) != {r['id'] for r in records}:
        raise ValueError('Expected exactly the 22 reviewed TOPAS products')
    apply, reverse = [], []
    for record in records:
        row = rows[record['id']]
        if (row.get('shop_id') != 1 or row.get('shop_group_id') != 10
                or row.get('deleted') != 0 or row.get('path') != record['path']):
            raise ValueError('Product identity differs')
        if any(field not in row for field in FIELDS):
            raise ValueError('Export lacks a required current text field')
        before = {field: row[field] for field in FIELDS}
        for value in before.values():
            literal(value)
        after = {field: record[field] for field in FIELDS if field != 'description'}
        after['description'] = (CONTENT / record['file']).read_text()
        apply.append(statement(row, before, after))
        reverse.append(statement(row, after, before))
    prefix = ('-- TOPAS product SEO. Fresh target export and backup required.\n'
              '-- This script does not update product properties or rebuild the filter.\n'
              '-- Check every changed_rows result; expected 1 per reviewed product.\n'
              'SET NAMES utf8mb4;\nSTART TRANSACTION;\n')
    suffix = '\n-- Deliberate dry run: review before choosing COMMIT.\nROLLBACK;\n'
    return (prefix + '\n'.join(apply) + suffix,
            prefix + '\n'.join(reverse) + suffix)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--export', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    apply, reverse = generate(json.loads(args.export.read_text()))
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / 'apply.sql').write_text(apply)
    (args.output / 'rollback.sql').write_text(reverse)
    print('Prepared two dry-run scripts; neither was executed.')
