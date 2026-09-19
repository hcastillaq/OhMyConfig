import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';

// Astro runs from apps/docs for both `npm run dev` and `npm run build`.
const versionFile = resolve(process.cwd(), '../../VERSION');

export const PROJECT_VERSION = readFileSync(versionFile, 'utf-8').trim();

if (!PROJECT_VERSION) {
  throw new Error(`Project version file is empty: ${versionFile}`);
}
