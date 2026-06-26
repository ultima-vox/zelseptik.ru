import { rm } from 'node:fs/promises';
await rm('dist/css/app.css', { force: true });
await rm('dist/css/app.min.css', { force: true });
