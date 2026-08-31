---
name: nvim-lazyvim-extension
description: "Trigger: nuevo plugin nvim, configurar lua, nvim extra, lazyvim plugin, neovim config. Guía la adición y configuración segura de plugins en Neovim respetando LazyVim Core."
---

# Neovim LazyVim Extension Skill

Esta skill define la arquitectura y el protocolo para extender el editor Neovim en **OhMyConfig** sin degradar el rendimiento de arranque ni romper la compatibilidad con **LazyVim Core**.

---

## Arquitectura de Neovim en OhMyConfig

```text
config/nvim/
├── init.lua             # Entry point (bootstrap de lazy.nvim)
├── lazyvim.json         # Módulos LazyExtras habilitados dinámicamente
└── lua/
    ├── config/
    │   ├── options.lua  # User vim.opt (números híbridos, undo persistente)
    │   ├── keymaps.lua  # Mapeos de navegación y splits (<leader> = Space)
    │   ├── autocmds.lua # Hooks de eventos
    │   └── lazy.lua     # Configuración del core de LazyVim
    └── plugins/
        ├── colorscheme.lua # Tokyonight Night con transparencia adaptativa
        ├── neo-tree.lua    # Símbolos limpios de Git sin cajas vacías
        └── neogen.lua      # Generación de docstrings (<leader>cn)
```

---

## Reglas de Diseño Inmutables

1. **LazyExtras Primero:**
   - Si se requiere soporte para un lenguaje o framework (TypeScript, Python, Docker, Tailwind, Rust, Go), **NO** instalar plugins sueltos a mano.
   - Utilizar el ecosistema de LazyExtras editando `lazyvim.json` o ejecutando `:LazyExtras` (`<Space> + px`).

2. **Modularidad en `lua/plugins/*.lua`:**
   - Todo nuevo plugin de usuario debe crearse en su propio archivo modular: `config/nvim/lua/plugins/<nombre-plugin>.lua`.
   - Exportar siempre una tabla con la especificación de `lazy.nvim` (`return { ... }`).
   - Usar `opts` para sobrescribir configuraciones en lugar de re-ejecutar `config = function()`.

3. **Carga Diferida (*Lazy Loading*):**
   - No cargar plugins en el inicio si no son necesarios inmediatamente.
   - Usar triggers de carga como `event = "VeryLazy"`, `ft = { "markdown", ... }` o `keys = { ... }`.

4. **Preservar Transparencia y Tokyonight:**
   - Cualquier plugin que cree ventanas flotantes o buffers (Telescope, Snacks, Neo-tree, Which-key) debe respetar el tema Tokyonight configurado en `colorscheme.lua`.

---

## Protocolo para Agregar un Plugin

1. Crear el archivo `config/nvim/lua/plugins/<plugin>.lua`.
2. Definir la especificación mínima con `opts`:
   ```lua
   return {
     "autor/plugin.nvim",
     event = "VeryLazy",
     opts = {
       -- opciones específicas de usuario
     },
   }
   ```
3. Abrir Neovim con `nvim` y verificar que `:Lazy` descargue y configure el plugin sin errores.
4. Documentar los atajos nuevos en `docs/neovim.md` y `docs/cheatsheet.md`.
