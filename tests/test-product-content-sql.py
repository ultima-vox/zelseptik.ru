import copy
import importlib.util
import json
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


if __name__ == '__main__':
    unittest.main()
