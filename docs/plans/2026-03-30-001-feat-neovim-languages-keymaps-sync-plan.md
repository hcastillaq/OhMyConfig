---
title: Configuración de Neovim para Lenguajes, Ergonomía de Atajos y Sincronización Global
type: feat
status: completed
date: 2026-03-30
origin: docs/brainstorms/2026-03-30-neovim-languages-keymaps-requirements.md
reviewed: 2026-03-30
---

# Configuración de Neovim para Lenguajes, Ergonomía de Atajos y Sincronización Global

## Overview

Este plan define la implementación técnica para dotar a Neovim (bajo LazyVim Core) de soporte completo para desarrollo en **Java, Go, Rust, Angular, PHP, Python y TypeScript**. Asimismo, resuelve el conflicto crítico de keymaps eliminando el override de `<leader>w` en `keymaps.lua`, preserva los proxies dinámicos nativos de LazyVim para ventanas (`<leader>w`) y buffers (`<leader>b`) en Which-Key v3 con soporte para modos normal y visual en español, y sincroniza todos los atajos de código en la función interactiva `guia` de Fish y la documentación oficial de OhMyConfig.

---

## Problem Frame

OhMyConfig utiliza Neovim como su editor IDE principal. La configuración base en `config/nvim/lazyvim.json` solo incluye soporte activo para Python y TypeScript. Para desarrolladores políglotas o principiantes que necesitan trabajar en Java, Go, Rust, Angular o PHP, la configuración requiere configurar manualmente LSPs, formatters y parsers.

Además, existe un conflicto ergonómico: en `config/nvim/lua/config/keymaps.lua`, la línea 21 mapea directamente `<leader>w` a `:w<CR>`, lo que anula la jerarquía de ventanas (`<leader>w`) de LazyVim y bloquea el acceso a sus proxies (`<c-w>`). A su vez, los atajos esenciales de código (ir a definición, interfaz, hover docs, sugerencias modales, comentarios, docstrings y búsqueda/reemplazo) carecen de visibilidad en Which-Key y se encuentran documentados de forma dispar en `config/fish/functions/guia.fish`, `docs/neovim.md` y `docs/cheatsheet.md`.

---

## Requirements Trace

### Soporte de Lenguajes y Toolchains (LazyExtras & Mason)
- R1. Habilitar en `config/nvim/lazyvim.json` los extras oficiales de LazyVim para Go (`lang.go`), Rust (`lang.rust`), Java (`lang.java`), Angular (`lang.angular`) y PHP (`lang.php`), conservando los existentes (`docker`, `json`, `markdown`, `python`, `typescript`, `yaml`).
- R2. Asegurar el aprovisionamiento de LSPs y formatters (`jdtls`, `gopls`, `phpactor`, `@angular/language-server`, `vtsls`), aclarando que `rust-analyzer` se obtiene mediante el componente nativo de Rust (`rustup component add rust-analyzer`).

### Navegación e Inteligencia de Código (LSP)
- R3. Visibilizar y documentar atajos de navegación de código: Ir a Definición (`gd`), Ir a Implementación/Interfaz (`gI`), Ir a Definición de Tipo (`gy`).
- R4. Acceso inmediato a ayuda contextual: Hover docs (`K`) y diagnóstico de línea flotante (`<leader>cd`).
- R5. Sugerencias y correcciones: Autocompletado contextual (`<C-Space>` en inserción), selección incremental (`<C-Space>` en normal/visual) y menú de Code Actions / QuickFix (`<leader>ca`).
- R6. Edición y documentación: Comentarios de línea/bloque (`gcc` / `gc`) y generación inteligente de docstrings (`neogen` vía `<leader>cn`).
- R7. Renombrado de símbolos en proyecto/archivo con `<leader>cr`.

### Búsqueda, Referencias y Reemplazo Visual
- R8. Visualización de referencias y usos (`gr`) y búsqueda de palabra bajo el cursor (`<leader>sw` y `*`).
- R9. Visibilizar y documentar el soporte nativo de búsqueda y reemplazo visual interactivo mediante `grug-far.nvim` (ya presente en el Core de LazyVim vía `<leader>sr`).

### Ergonomía de Ventanas y Guardado
- R10. Eliminar la asignación conflictiva de `<leader>w` a `:w<CR>` en `keymaps.lua`, restaurando el menú nativo de Ventanas y Splits (`<leader>w`) y permitiendo que opere el guardado universal nativo de LazyVim en `<C-s>`.

### Integración y Visibilidad Git
- R11. Asegurar la visibilidad de los atajos de Git (`<leader>gg` para Lazygit, `<leader>gb` blame, `<leader>gd` diff).

### Etiquetado Amigable en Which-Key
- R12. Crear `config/nvim/lua/plugins/which-key.lua` configurando grupos descriptivos en español para Which-Key v3 con soporte bimodal (`mode = { "n", "v" }`) y preservando explícitamente los proxies nativos (`proxy = "<c-w>"` y `expand`).

### Sincronización de Terminal (Fish) y Documentación
- R13. Actualizar la función interactiva `guia` en `config/fish/functions/guia.fish` reflejando la totalidad de los atajos actualizados, diferenciando el comportamiento modal de `<C-Space>` e incorporando comandos rápidos de `mise`.
- R14. Actualizar `docs/neovim.md` y `docs/cheatsheet.md` incluyendo tablas de atajos sincronizados, guía de búsqueda/reemplazo con Grug-Far y aprovisionamiento de SDKs vía `mise`.

---

## Scope Boundaries

- No se forzará la instalación de runtimes pesados (JDK 21, Rust toolchain, Go SDK, PHP CLI) dentro de `Brewfile` ni en `./omc install`; se gestionan a demanda del usuario vía `mise`.
- No se añadirá `"lazyvim.plugins.extras.editor.grug-far"` a `lazyvim.json`, ya que `grug-far.nvim` está integrado en el core de LazyVim.
- No se remapeará `<C-s>` en `keymaps.lua` dado que LazyVim Core ya lo implementa universalmente para los modos normal, inserción, visual y selección.
- No se alterarán los atajos modales clásicos de Neovim (`hjkl`, `w`, `b`, `u`, `y`).

---

## Context & Research

### Relevant Code and Patterns

- `config/nvim/lazyvim.json`: Registro declarativo de extras oficiales de LazyVim.
- `config/nvim/lua/config/keymaps.lua`: Atajos de usuario sobre LazyVim (línea 21 contiene el mapeo conflictivo a eliminar).
- `config/nvim/lua/plugins/`: Directorio modular de especificaciones de plugins de LazyVim.
- `config/fish/functions/guia.fish`: Cheatsheet interactivo en terminal Fish.
- `docs/neovim.md` & `docs/cheatsheet.md`: Documentación oficial en Markdown construida con VitePress.

### Institutional Learnings & Rules

- **LazyExtras First (`nvim-lazyvim-extension`):** Para soporte de lenguajes, utilizar únicamente `lazyvim.json` (`lazyvim.plugins.extras.lang.*`).
- **Grug-Far en LazyVim Core:** LazyVim Core ya registra `MagicDuck/grug-far.nvim` en `lua/lazyvim/plugins/editor.lua` con `<leader>sr`. No requiere extra adicional.
- **Which-Key v3 Proxy & Modes Invariant:** Los grupos `<leader>w` y `<leader>b` en Which-Key v3 deben retener sus atributos `proxy` y `expand` para no romper los comandos nativos de split y previsualización. Los grupos deben declarar `mode = { "n", "v" }` para mantenerse consistentes al seleccionar texto.
- **Invariante de Sincronización Triad:** Todo cambio en atajos debe propagarse exactamente a: 1. Runtime Lua, 2. Función Fish (`guia.fish`), 3. Docs (`neovim.md` y `cheatsheet.md`).
- **Validación VitePress:** Todo cambio en documentación debe validar limpiamente con `npx vitepress build`.

---

## Key Technical Decisions

- **Uso estricto de LazyVim Extras oficiales (`lazyvim.json`):** Añadir únicamente los 5 extras de lenguaje requeridos:
  - `"lazyvim.plugins.extras.lang.angular"`
  - `"lazyvim.plugins.extras.lang.go"`
  - `"lazyvim.plugins.extras.lang.java"`
  - `"lazyvim.plugins.extras.lang.php"`
  - `"lazyvim.plugins.extras.lang.rust"`
- **Restauración de `<leader>w` y Guardado Nativo:** Eliminar la línea 21 de `config/nvim/lua/config/keymaps.lua` (`map("n", "<leader>w", ":w<CR>", ...)`). Esto restaura el prefijo `<leader>w` para ventanas y permite que el mapeo nativo de LazyVim para `<C-s>` (`<cmd>w<cr><esc>`) funcione sin interferencias en modo normal e inserción.
- **Which-Key v3 con Preservación de Proxies y Modos:** Crear `config/nvim/lua/plugins/which-key.lua` utilizando `opts.spec` para personalizar los textos en español abarcando normal y visual:
  ```lua
  return {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>c", group = "código (acciones, rename, doc)", mode = { "n", "v" } },
        { "<leader>g", group = "git (lazygit, blame, diff)", mode = { "n", "v" } },
        { "<leader>s", group = "buscar y reemplazar (grep, files, grug-far)", mode = { "n", "v" } },
        {
          "<leader>w",
          group = "ventanas y divisiones",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        {
          "<leader>b",
          group = "pestañas y buffers",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        { "<leader>x", group = "errores y diagnósticos (trouble)", mode = { "n", "v" } },
        { "<leader>u", group = "opciones visuales (toggles)", mode = { "n", "v" } },
        { "<leader>p", group = "gestión de paquetes y extras (lazy, mason)", mode = { "n", "v" } },
      },
    },
  }
  ```
- **Guía de SDKs con `mise` y Prevención de Errores LSP:** Documentar en `docs/neovim.md` y resumir en `guia.fish` cómo aprovisionar los SDKs de sistema para evitar errores flotantes de LSP:
  - Java: `mise use -g java@openjdk-21` (Requerido por `jdtls`)
  - Go: `mise use -g go@latest` (Requerido por `gopls`)
  - Rust: `mise use -g rust@latest && rustup component add rust-analyzer` (Requerido por `rustaceanvim`)
  - PHP: `mise use -g php@latest` (Requerido por el wrapper `.phar` de `phpactor`)

---

## Implementation Units

- [x] U1. **Habilitar Extras de Lenguajes en `lazyvim.json`**

**Goal:** Registrar de forma declarativa los extras oficiales de LazyVim para Java, Go, Rust, Angular y PHP.

**Requirements:** R1, R2

**Dependencies:** Ninguna

**Files:**
- Modify: `config/nvim/lazyvim.json`

**Approach:**
- Añadir en el array `"extras"` en orden alfabético:
  - `"lazyvim.plugins.extras.lang.angular"`
  - `"lazyvim.plugins.extras.lang.go"`
  - `"lazyvim.plugins.extras.lang.java"`
  - `"lazyvim.plugins.extras.lang.php"`
  - `"lazyvim.plugins.extras.lang.rust"`
- Conservar intactos los extras existentes (`docker`, `json`, `markdown`, `python`, `typescript`, `yaml`).
- No agregar entradas inexistentes para grug-far.

**Patterns to follow:**
- Formato JSON estándar de LazyVim.

**Test scenarios:**
- Happy path: `jq . config/nvim/lazyvim.json` retorna 0 sin errores sintácticos.
- Happy path: El array `"extras"` contiene exactamente 11 extras válidos sin duplicados.

**Verification:**
- `jq . config/nvim/lazyvim.json` valida exitosamente.

---

- [x] U2. **Resolver Conflicto de Keymaps en `keymaps.lua`**

**Goal:** Eliminar el override de `<leader>w` para restaurar el submenú de ventanas y habilitar el guardado universal nativo `<C-s>`.

**Requirements:** R10

**Dependencies:** Ninguna

**Files:**
- Modify: `config/nvim/lua/config/keymaps.lua`

**Approach:**
- Eliminar la línea: `map("n", "<leader>w", ":w<CR>", vim.tbl_extend("force", opts, { desc = "Guardar archivo" }))`.
- Documentar en el encabezado del archivo que el guardado universal se realiza con `<C-s>` (nativo de LazyVim en modo normal e inserción) y que `<leader>w` pertenece al subsistema de ventanas.
- No introducir código redundante para `<C-s>` ni mapeos que colisionen con `<leader>sw`.

**Patterns to follow:**
- Idioma y estilo de configuración de `config/nvim/lua/config/keymaps.lua`.

**Test scenarios:**
- Happy path: El archivo Lua es sintácticamente válido (`luac -p config/nvim/lua/config/keymaps.lua` o comprobación headless de nvim).
- Verification: Ninguna línea del archivo mapea `<leader>w` a `:w`.

**Verification:**
- `git diff config/nvim/lua/config/keymaps.lua` muestra únicamente la eliminación de la línea conflictiva y comentarios aclaratorios.

---

- [x] U3. **Configurar Which-Key v3 con Etiquetas en Español, Proxies y Modos Preservados**

**Goal:** Crear la especificación de `which-key.nvim` para mostrar nombres de grupos descriptivos en español sin destruir los proxies nativos de ventanas/buffers y soportando selección visual.

**Requirements:** R12

**Dependencies:** U2

**Files:**
- Create: `config/nvim/lua/plugins/which-key.lua`

**Approach:**
- Crear `config/nvim/lua/plugins/which-key.lua` retornando la tabla lazy para `folke/which-key.nvim`.
- Configurar `opts.spec` con los grupos en español y `mode = { "n", "v" }`:
  - `<leader>c` -> `+código (acciones, rename, doc)`
  - `<leader>g` -> `+git (lazygit, blame, diff)`
  - `<leader>s` -> `+buscar y reemplazar (grep, files, grug-far)`
  - `<leader>w` -> `+ventanas y divisiones (splits, resize)` con `proxy = "<c-w>"` y `expand = function() return require("which-key.extras").expand.win() end`
  - `<leader>b` -> `+pestañas y buffers` con `expand = function() return require("which-key.extras").expand.buf() end`
  - `<leader>x` -> `+errores y diagnósticos (trouble)`
  - `<leader>u` -> `+opciones visuales (toggles)`
  - `<leader>p` -> `+gestión de paquetes y extras (lazy, mason)`

**Patterns to follow:**
- Patrón de specs modulares de LazyVim en `config/nvim/lua/plugins/`.

**Test scenarios:**
- Happy path: El archivo `config/nvim/lua/plugins/which-key.lua` es sintácticamente correcto en Lua.
- Regression check: La configuración preserva explícitamente `proxy = "<c-w>"` en `<leader>w` y `expand` en `<leader>w` y `<leader>b`.

**Verification:**
- Verificación sintáctica con `luac -p config/nvim/lua/plugins/which-key.lua` o ejecución headless de Neovim sin errores.

---

- [x] U4. **Sincronizar Función Interactiva `guia.fish` en Shell Fish**

**Goal:** Actualizar la función interactiva `guia` para reflejar con precisión los atajos reales de Neovim en la terminal y guías de runtimes.

**Requirements:** R3, R4, R5, R6, R7, R8, R9, R11, R13

**Dependencies:** U2, U3

**Files:**
- Modify: `config/fish/functions/guia.fish`

**Approach:**
- En la vista general (`if test -z "$cat" -o "$cat" = "all"`):
  - Actualizar guardado: `Ctrl + s` -> `"Guardar archivo actual (modo normal e inserción)"`.
  - Añadir ventanas: `<Space> + w` -> `"Ventanas y divisiones (splits: s, v, d)"`.
  - Añadir acciones de código: `<Space> + ca` -> `"Acciones de código y correcciones (QuickFix)"`.
  - Añadir buscar/reemplazar: `<Space> + sr` -> `"Buscar y reemplazar en todo el proyecto (Grug-Far)"`.
- En la sección especializada (`case "nvim" "v" "vim" "editor"`):
  - Incluir `Ctrl + s`: Guardar archivo actual en cualquier modo.
  - Incluir `<Space> + w`: Ventanas y divisiones (`s` horizontal, `v` vertical, `d` cerrar).
  - Incluir `gd / gI / gy`: Ir a definición / interfaz / tipo (LSP).
  - Incluir `K`: Documentación y tipos flotantes (Hover).
  - Incluir `<Space> + ca`: Acciones rápidas y correcciones sugeridas.
  - Incluir `<Space> + cd`: Diagnóstico y error de la línea actual.
  - Incluir `<Space> + cr`: Renombrar variable en todo el proyecto.
  - Incluir `gr / <Space> + sw`: Ver referencias / Buscar palabra bajo el cursor en archivos.
  - Incluir `<Space> + sr`: Buscar y reemplazar interactivo (Grug-Far).
  - Incluir `<Space> + cn`: Generar comentarios de documentación (Neogen).
  - Incluir `gcc / gc`: Comentar línea o bloque de código.
  - Incluir `<Space> + gg / gb / gd`: Lazygit flotante / Git blame / Git diff.
  - Explicar diferencia modal de `Ctrl + Space`: selección incremental en normal/visual y autocompletado en inserción.
  - Añadir comando rápido de instalación de SDKs (`mise use -g java, go, rust, php`).

**Patterns to follow:**
- Formato de colores Tokyonight ANSI (`$c_key`, `$c_txt`, `$c_sec`) existente en `guia.fish`.

**Test scenarios:**
- Happy path: `fish -n config/fish/functions/guia.fish` valida sin errores de sintaxis.
- Consistency check: Ninguna línea en `guia.fish` menciona `<Space> + w` para guardar.

**Verification:**
- `fish -n config/fish/functions/guia.fish` retorna código 0.

---

- [x] U5. **Actualizar Guías de Usuario y Cheatsheets (`docs/neovim.md` y `docs/cheatsheet.md`)**

**Goal:** Actualizar exhaustivamente la documentación de Neovim y la tabla maestra de cheatsheets para reflejar todos los lenguajes, atajos y comandos de SDKs con `mise`.

**Requirements:** R3, R4, R5, R6, R7, R8, R9, R11, R14

**Dependencies:** U1, U2, U3, U4

**Files:**
- Modify: `docs/neovim.md`
- Modify: `docs/cheatsheet.md`

**Approach:**
- En `docs/neovim.md`:
  - Añadir sección "Soporte de Lenguajes y Toolchains (Java, Go, Rust, Angular, PHP, Python, TypeScript)" con tabla de LSPs y comandos `mise` recomendados (detallando `rustup component add rust-analyzer` y runtime PHP para `phpactor`).
  - Añadir sección "Inteligencia y Acciones de Código (LSP)" detallando `gd`, `gI`, `gy`, `K`, `<leader>ca`, `<leader>cd`, `<leader>cr`, `gr`, `gcc`/`gc`, `<leader>cn`.
  - Aclarar el comportamiento modal de `<C-Space>` (modo normal: selección incremental; modo inserción: autocompletado).
  - Añadir sección "Buscar y Reemplazar Visual (Grug-Far)" explicando `<leader>sr` en modo normal y con selección visual.
  - Actualizar tabla de ventanas y guardado (`<C-s>` para guardar y `<leader>w` para ventanas).
  - Añadir tabla de atajos visuales de Git (`<leader>gg`, `<leader>gb`, `<leader>gd`).
- En `docs/cheatsheet.md`:
  - Actualizar la tabla de Neovim con todos los atajos nuevos y corregidos, eliminando `<Space> + w` para guardar.
- Validar la compilación con VitePress.

**Patterns to follow:**
- Estilo Markdown Tokyonight y tablas de referencia de OhMyConfig.

**Test scenarios:**
- Happy path: `npx vitepress build` compila la documentación sin errores ni enlaces rotos.
- Content check: `docs/neovim.md` y `docs/cheatsheet.md` están 100% alineados con `keymaps.lua`, `which-key.lua` y `guia.fish`.

**Verification:**
- `npx vitepress build` finaliza con código 0.

---

## System-Wide Impact

- **Interaction graph:** `config/nvim/lazyvim.json` instruye a `lazy.nvim` y `mason.nvim` para la descarga automática de los nuevos LSPs en el próximo arranque de Neovim. `keymaps.lua` y `which-key.lua` configuran el comportamiento modal sin alterar atajos nativos de LazyVim.
- **Error propagation:** Se previene la confusión de errores de LSP documentando explícitamente los comandos de SDKs (`mise use -g`) y componentes nativos (`rustup component add rust-analyzer`) en la terminal (`guia.fish`) y en las guías oficiales (`docs/neovim.md`).
- **API surface parity:** La tríada (Neovim Lua, Fish `guia`, VitePress docs) queda 100% sincronizada.
- **Unchanged invariants:** La navegación entre ventanas con `Ctrl + h/j/k/l`, el explorador Neo-tree con `<leader>e`, el salto instantáneo con `s` (Flash) y los docstrings con `<leader>cn` (Neogen) se mantienen intactos.

---

## Risks & Dependencies

| Risk | Mitigation |
|------|------------|
| Mason requiere Java 17+ para iniciar `jdtls` | Documentar en `docs/neovim.md` y en `guia nvim` el comando `mise use -g java@openjdk-21` |
| `rustaceanvim` requiere `rust-analyzer` en `$PATH` | Documentar `rustup component add rust-analyzer` junto con `mise use -g rust` |
| `phpactor` requiere el ejecutable `php` en `$PATH` | Documentar `mise use -g php@latest` en la guía de lenguajes |
| Sobrescritura accidental de proxies de Which-Key v3 | U3 incluye explícitamente `proxy = "<c-w>"` y los callbacks de `expand` para ventanas y buffers en modo normal y visual |
| Desincronización de atajos entre shell y editor | U4 y U5 se ejecutan junto con los cambios en Lua garantizando coherencia inmediata |

---

## Sources & References

- **Origin document:** `docs/brainstorms/2026-03-30-neovim-languages-keymaps-requirements.md`
- LazyVim Language Extras: `lazyvim.plugins.extras.lang.*`
- LazyVim Core Editor Plugins: `lua/lazyvim/plugins/editor.lua` (`MagicDuck/grug-far.nvim`)
- Which-Key v3 Mappings & Proxies Documentation
