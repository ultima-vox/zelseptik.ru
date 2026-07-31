import { readFile, writeFile } from 'node:fs/promises';

const files = [
  'core/header.css',
  'core/hero.css',
  'dist/css/critical-app.min.css',
];

const parts = await Promise.all(
  files.map(async (file) => (await readFile(file, 'utf8')).replace(/^\uFEFF/, '')),
);

await writeFile('dist/css/critical.css', `@charset "UTF-8";\n${parts.join('\n')}\n`);
