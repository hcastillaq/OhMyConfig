export default {
  title: "OhMyConfig",
  description: "Dotfiles y Entorno de Desarrollo Moderno para macOS (Tokyonight)",
  lang: "es-ES",
  base: "/OhMyConfig/",
  srcDir: "docs",
  srcExclude: ["**/brainstorms/**", "**/plans/**"],
  cleanUrls: true,

  themeConfig: {
    logo: { text: "⚡ OhMyConfig" },
    nav: [
      { text: "Inicio", link: "/" },
      { text: "Instalación", link: "/instalacion" },
      { text: "AI & Agentes", link: "/ai" },
      { text: "Neovim", link: "/neovim" },
      { text: "Zellij", link: "/zellij" },
      { text: "Git", link: "/git" },
      { text: "Cheatsheet", link: "/cheatsheet" },
    ],

    sidebar: [
      {
        text: "🚀 Primeros Pasos",
        items: [
          { text: "Instalación & Brewfile", link: "/instalacion" },
          { text: "Ecosistema AI & Agentes", link: "/ai" },
        ],
      },
      {
        text: "🛠️ Herramientas Centrales",
        items: [
          { text: "Neovim (Editor Principal)", link: "/neovim" },
          { text: "Zellij (Multiplexor)", link: "/zellij" },
          { text: "Git, Lazygit & Delta", link: "/git" },
          { text: "Terminal, Fish & Starship", link: "/terminal" },
        ],
      },
      {
        text: "📖 Referencia",
        items: [
          { text: "Herramientas CLI / TUI", link: "/herramientas" },
          { text: "Tabla Maestra de Atajos", link: "/cheatsheet" },
        ],
      },
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/hcastillaq/OhMyConfig" },
    ],

    search: {
      provider: "local",
      options: {
        locales: {
          root: {
            translations: {
              button: {
                buttonText: "Buscar en la documentación...",
                buttonAriaLabel: "Buscar",
              },
              modal: {
                noResultsText: "No se encontraron resultados para",
                resetButtonTitle: "Limpiar búsqueda",
                footer: {
                  selectText: "para seleccionar",
                  navigateText: "para navegar",
                  closeText: "para cerrar",
                },
              },
            },
          },
        },
      },
    },

    footer: {
      message: "OhMyConfig — Publicado bajo licencia MIT.",
      copyright: "Diseñado para macOS con paleta Tokyonight Night.",
    },
  },
}
