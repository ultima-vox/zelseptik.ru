"""Check preserved originals, production snapshot and local module references."""
import hashlib
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
errors = []
checked = 0
for manifest, key in [('docs/production-assets.json', 'path'), ('archive/2026-10-05/manifest.json', 'archived_path')]:
    for row in json.loads((ROOT / manifest).read_text(encoding='utf-8'))['files']:
        path = ROOT / row[key]
        if not path.is_file():
            errors.append('Missing: ' + row[key])
        elif hashlib.sha256(path.read_bytes()).hexdigest() != row['sha256']:
            errors.append('Hash differs from baseline: ' + row[key])
        checked += 1

for path in (ROOT / 'assets/js').rglob('*.js'):
    text = path.read_text(encoding='utf-8')
    for reference in re.findall(r"(?:from\s*|import\s*)['\"]([^'\"]+)['\"]", text):
        if reference.startswith('.') and not (path.parent / reference).resolve().is_file():
            errors.append(f'Missing JS import: {path.relative_to(ROOT)} -> {reference}')

for path in (ROOT / 'hostcmsfiles/xsl').glob('*.xsl'):
    text = path.read_text(encoding='utf-8')
    for reference in re.findall(r'<xsl:(?:include|import)[^>]*href=[\"\']([^\"\']+)', text):
        if reference.startswith('import://'):
            dependency = path.parent / (reference.removeprefix('import://') + '.xsl')
        elif '://' not in reference:
            dependency = path.parent / reference
        else:
            continue
        if not dependency.is_file():
            errors.append(f'Missing XSL import: {path.relative_to(ROOT)} -> {reference}')

if errors:
    print('\n'.join(errors))
    sys.exit(1)
print(f'OK: {checked} checksums; JS and XSL imports resolved.')
