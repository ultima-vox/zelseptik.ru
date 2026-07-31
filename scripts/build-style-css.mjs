import { readFile, writeFile } from 'node:fs/promises';

const files = ['dist/css/runtime.min.css', 'dist/css/app.min.css'];
const parts = await Promise.all(
  files.map(async (file) => (await readFile(file, 'utf8')).replace(/^\uFEFF/, '')),
);

await writeFile('dist/css/style.min.css', `@charset "UTF-8";\n${parts.join('\n')}\n`);
