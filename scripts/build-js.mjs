import { cp, mkdir, rm } from 'node:fs/promises';

const source = 'src/js';
const destination = 'dist/js';

await rm(destination, { force: true, recursive: true });
await mkdir(destination, { recursive: true });
await cp(source, destination, { recursive: true });
