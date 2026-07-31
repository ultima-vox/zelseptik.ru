import { rm } from 'node:fs/promises';

await Promise.all([
  rm('dist/css/app.css', { force: true }),
  rm('dist/css/app.css.map', { force: true }),
  rm('dist/css/app.min.css', { force: true }),
  rm('dist/css/runtime.css', { force: true }),
  rm('dist/css/runtime.min.css', { force: true }),
  rm('dist/css/style.min.css', { force: true }),
  rm('dist/js', { force: true, recursive: true }),
]);
