"""Generate guarded, rollback-by-default SQL from a fresh native Shop 6 export."""
import argparse
import json
from pathlib import Path

FIELDS = ('text', 'seo_title', 'seo_description')
ROOT = Path(__file__).resolve().parents[2]
CONTENT = ROOT / 'docs/seo-content/cities-2026-10-07'


def literal(value):
    if value is None:
        return 'NULL'
    if not isinstance(value, str):
        raise ValueError('Expected string or null')
    # Hex avoids shell, SQL escaping and NO_BACKSLASH_ESCAPES dependencies.
    return "CONVERT(X'%s' USING utf8mb4)" % value.encode('utf-8').hex()


def update(row, before, after):
    guard = [f"id = {row['id']}", 'shop_id = 6', 'deleted = 0',
             'BINARY path = BINARY ' + literal(row['path'])]
    guard += ['BINARY ' + field + ' <=> BINARY ' + literal(before[field]) for field in FIELDS]
    assignments = ', '.join(field + ' = ' + literal(after[field]) for field in FIELDS)
    return 'UPDATE shop_items SET ' + assignments + ' WHERE ' + ' AND '.join(guard) + ';\nSELECT ROW_COUNT() AS changed_rows;'


def generate(export):
    if not isinstance(export, list):
        raise ValueError('Expected JSON array of current rows')
    if any(not isinstance(r, dict) for r in export):
        raise ValueError('Invalid export row')
    if len({r['id'] for r in export}) != len(export):
        raise ValueError('Duplicate IDs')
    rows = {r['id']: r for r in export}
    records = json.loads((CONTENT / 'manifest.json').read_text())['records']
    if set(rows) != {r['id'] for r in records}:
        raise ValueError('Export must contain exactly the reviewed five IDs')
    apply, rollback = [], []
    for record in records:
        row = rows[record['id']]
        if row['shop_id'] != 6 or row['deleted'] != 0 or row['path'] != record['path']:
            raise ValueError('Record identity differs from manifest')
        before = {field: row[field] for field in FIELDS}
        after = {field: record[field] for field in FIELDS if field != 'text'}
        after['text'] = (CONTENT / record['file']).read_text()
        apply.append(update(row, before, after))
        rollback.append(update(row, after, before))
    prefix = '-- DEV ONLY. Inspect every changed_rows result (must be 1).\nSET NAMES utf8mb4;\nSTART TRANSACTION;\n'
    suffix = '\n-- Default dry run. Replace with COMMIT only after verifying all rows.\nROLLBACK;\n'
    return prefix + '\n'.join(apply) + suffix, prefix + '\n'.join(rollback) + suffix


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--export', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    apply, rollback = generate(json.loads(args.export.read_text()))
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / 'apply.sql').write_text(apply)
    (args.output / 'rollback.sql').write_text(rollback)
    print('Generated apply.sql and rollback.sql; neither was executed.')
