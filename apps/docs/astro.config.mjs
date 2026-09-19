import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import { PROJECT_VERSION } from './src/config/version.mjs';

const version = PROJECT_VERSION;

export default defineConfig({
  site: 'https://hcastillaq.github.io',
  base: '/OhMyConfig/',
  integrations: [
    starlight({
      title: `OhMyConfig v${version}`,
      description: `Dotfiles y Entorno de Desarrollo Moderno para macOS (Static Noise) — v${version}`,
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/hcastillaq/OhMyConfig' },
      ],
      sidebar: [
        {
          label: 'Primeros Pasos',
          items: [
            { label: 'Instalación & Brewfile', slug: 'instalacion' },
            { label: 'Ecosistema AI & Pi', slug: 'ai' },
            { label: 'Pi Model Policy (Router)', slug: 'model-policy' },
          ],
        },
        {
          label: 'Herramientas Centrales',
          items: [
            { label: 'Neovim (Editor Principal)', slug: 'neovim' },
            { label: 'Zellij (Multiplexor)', slug: 'zellij' },
            { label: 'Git, Lazygit & Delta', slug: 'git' },
            { label: 'Terminal, Fish & Starship', slug: 'terminal' },
          ],
        },
        {
          label: 'Referencia',
          items: [
            { label: 'Herramientas CLI / TUI', slug: 'herramientas' },
            { label: 'Tabla Maestra de Atajos', slug: 'cheatsheet' },
          ],
        },
      ],
      customCss: ['./src/styles/custom.css'],
      components: {
        PageFrame: './src/components/CosmicPageFrame.astro',
        Header: './src/components/CosmicHeader.astro',
        SiteTitle: './src/components/CosmicSiteTitle.astro',
        Footer: './src/components/CosmicFooter.astro',
      },
    }),
  ],
});
