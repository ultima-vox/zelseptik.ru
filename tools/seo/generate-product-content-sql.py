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
    guard = [f"id = {row['id']}", 'shop_id = 1', f"shop_group_id = {row['shop_group_id']}",
             'deleted = 0', 'BINARY path = BINARY ' + literal(row['path'])]
    guard.extend('BINARY ' + field + ' <=> BINARY ' + literal(before[field])
                 for field in FIELDS)
    return ('UPDATE shop_items SET ' + ', '.join(
        field + ' = ' + literal(after[field]) for field in FIELDS)
        + ' WHERE ' + ' AND '.join(guard)
        + ';\nSELECT ROW_COUNT() AS changed_rows;')


def generate(export, content=CONTENT):
    content = Path(content).resolve()
    records = json.loads((content / 'manifest.json').read_text())
    if not isinstance(records, list) or not records:
        raise ValueError('Expected a nonempty reviewed product manifest')
    ids = set()
    for record in records:
        if (not isinstance(record, dict) or type(record.get('id')) is not int
                or record['id'] <= 0 or record['id'] in ids
                or type(record.get('shop_id')) is not int or record['shop_id'] != 1
                or type(record.get('shop_group_id')) is not int
                or record['shop_group_id'] <= 0
                or not isinstance(record.get('path'), str) or not record['path']
                or not isinstance(record.get('file'), str)):
            raise ValueError('Invalid reviewed product identity')
        ids.add(record['id'])
        source = (content / record['file']).resolve()
        if source.parent != content or source.suffix != '.html' or not source.is_file():
            raise ValueError('Description must be an HTML file within the content directory')
        for field in FIELDS[1:]:
            if field not in record:
                raise ValueError('Manifest lacks a required SEO field')
            literal(record[field])
    if not isinstance(export, list) or not all(isinstance(r, dict) for r in export):
        raise ValueError('Expected a list of fresh shop_items records')
    if not all(type(r.get('id')) is int for r in export):
        raise ValueError('IDs must be integers')
    rows = {r['id']: r for r in export}
    if len(rows) != len(export):
        raise ValueError('Duplicate IDs')
    if set(rows) != {r['id'] for r in records}:
        raise ValueError('Export must contain exactly the reviewed manifest IDs')
    apply, reverse = [], []
    for record in records:
        row = rows[record['id']]
        if (type(row.get('shop_id')) is not int or row['shop_id'] != 1
                or type(row.get('shop_group_id')) is not int
                or row['shop_group_id'] != record['shop_group_id']
                or type(row.get('deleted')) is not int or row['deleted'] != 0
                or row.get('path') != record['path']):
            raise ValueError('Product identity differs')
        if any(field not in row for field in FIELDS):
            raise ValueError('Export lacks a required current text field')
        before = {field: row[field] for field in FIELDS}
        for value in before.values():
            literal(value)
        after = {field: record[field] for field in FIELDS if field != 'description'}
        after['description'] = (content / record['file']).read_text()
        apply.append(statement(row, before, after))
        reverse.append(statement(row, after, before))
    prefix = ('-- Reviewed product SEO. Fresh target export and backup required.\n'
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
    parser.add_argument('--content', type=Path, default=CONTENT,
                        help='Reviewed manifest and HTML directory; defaults to TOPAS')
    args = parser.parse_args()
    apply, reverse = generate(json.loads(args.export.read_text()), args.content)
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / 'apply.sql').write_text(apply)
    (args.output / 'rollback.sql').write_text(reverse)
    print('Prepared two dry-run scripts; neither was executed.')
