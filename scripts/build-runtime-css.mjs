import { readFile, mkdir, writeFile } from 'node:fs/promises';

const files = [
  'tokens',
  'base',
  'typography',
  'layout',
  'components',
  'header',
  'hero',
  'trust',
  'catalog',
  'media',
  'comparison',
  'home-sections',
  'faq',
  'cta',
  'modal',
  'footer',
  'animation',
];

const parts = await Promise.all(
  files.map(async (name) => {
    const css = await readFile(`core/${name}.css`, 'utf8');
    return `/* core/${name}.css */\n${css.replace(/^\uFEFF/, '')}`;
  }),
);

await mkdir('dist/css', { recursive: true });
await writeFile('dist/css/runtime.css', parts.join('\n'));
