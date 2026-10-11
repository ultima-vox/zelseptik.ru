import copy
import importlib.util
import json
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    'product_sql', ROOT / 'tools/seo/generate-product-content-sql.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class ProductMigrationTests(unittest.TestCase):
    def setUp(self):
        manifest = json.loads((module.CONTENT / 'manifest.json').read_text())
        self.rows = [dict(id=r['id'], shop_id=1, shop_group_id=10,
                          path=r['path'], deleted=0, description="before ' \\ 😀",
                          seo_title=None, seo_description='', seo_keywords='old')
                     for r in manifest]

    def test_dry_run_and_concurrent_edit_guards(self):
        apply, reverse = module.generate(self.rows)
        for sql in (apply, reverse):
            self.assertTrue(sql.endswith('ROLLBACK;\n'))
            self.assertEqual(sql.count('UPDATE shop_items SET'), 22)
            self.assertEqual(sql.count('SELECT ROW_COUNT()'), 22)
            self.assertEqual(sql.count('BINARY description <=> BINARY'), 22)
            self.assertNotIn("before ' \\ 😀", sql)
            self.assertNotIn('UPDATE property_', sql)
        self.assertIn('BINARY seo_title <=> BINARY NULL', apply)
        self.assertIn('seo_title = NULL', reverse)

    def test_rejects_wrong_target_or_incomplete_export(self):
        for key, value in [('shop_id', 6), ('shop_group_id', 11),
                           ('deleted', 1), ('path', 'another-product'),
                           ('id', '111 OR 1=1')]:
            rows = copy.deepcopy(self.rows)
            rows[0][key] = value
            with self.assertRaises(ValueError):
                module.generate(rows)
        with self.assertRaises(ValueError):
            module.generate(self.rows + [self.rows[0]])
        rows = copy.deepcopy(self.rows)
        del rows[0]['description']
        with self.assertRaises(ValueError):
            module.generate(rows)

    def test_eco_grand_batch_guards_and_rollback(self):
        content = ROOT / 'docs/seo-content/products-eco-grand-2026-10-11'
        records = json.loads((content / 'manifest.json').read_text())
        rows = [dict(id=r['id'], shop_id=1, shop_group_id=15,
                     path=r['path'], deleted=0, description='previous',
                     seo_title=None, seo_description='', seo_keywords='old')
                for r in records]
        apply, reverse = module.generate(rows, content)
        for sql in (apply, reverse):
            self.assertEqual(sql.count('UPDATE shop_items SET'), 3)
            self.assertEqual(sql.count('shop_group_id = 15'), 3)
            self.assertTrue(sql.endswith('ROLLBACK;\n'))
        self.assertIn('description = ' + module.literal('previous'), reverse)
        rows[0]['shop_group_id'] = '15 OR 1=1'
        with self.assertRaises(ValueError):
            module.generate(rows, content)

    def test_rejects_invalid_manifest_or_external_description(self):
        records = json.loads((module.CONTENT / 'manifest.json').read_text())
        for key, value in [('id', True), ('shop_group_id', '10 OR 1=1'),
                           ('file', '../outside.html')]:
            with tempfile.TemporaryDirectory() as directory:
                content = Path(directory)
                for record in records:
                    (content / record['file']).write_text('description')
                changed = copy.deepcopy(records)
                changed[0][key] = value
                (content / 'manifest.json').write_text(json.dumps(changed))
                with self.assertRaises(ValueError):
                    module.generate(self.rows, content)


if __name__ == '__main__':
    unittest.main()
