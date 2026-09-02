---
date: 2026-03-30
topic: neovim-languages-keymaps
---

# Configuración de Neovim: Lenguajes (Java, Go, Rust, Angular, PHP), Ergonomía de Atajos y Sincronización Global

## Problem Frame

OhMyConfig utiliza Neovim sobre LazyVim como entorno de edición principal. Actualmente, la configuración básica solo incluye soporte activo para Python y TypeScript en `config/nvim/lazyvim.json`. Adicionalmente, existen inconsistencias ergonómicas en los atajos de teclado: `<leader>w` está mapeado directamente a `:w<CR>`, lo que rompe el grupo estándar de gestión de Ventanas (`<leader>w`) de LazyVim. 

Para programadores principiantes o que migran desde IDEs gráficos (como VS Code), la ausencia de soporte preconfigurado para lenguajes populares (Java, Go, Rust, Angular, PHP), la falta de visibilidad para acciones esenciales de código (ir a definición/implementación, ver ayudas/hover, aplicar correcciones sugeridas, comentar código y docstrings) y la ausencia de una interfaz visual clara para buscar y reemplazar dificultan una adopción fluida e intuitiva.

Por último, los atajos desactualizados o en conflicto también se encuentran documentados de forma divergente en `config/fish/functions/guia.fish`, `docs/neovim.md` y `docs/cheatsheet.md`, lo que desorienta a los usuarios al consultar la ayuda interactiva de la terminal.

---

## Requirements

**Soporte de Lenguajes y Toolchains**
- R1. Habilitar en `config/nvim/lazyvim.json` los extras oficiales de LazyVim para Go (`lang.go`), Rust (`lang.rust`), Java (`lang.java`), Angular (`lang.angular`) y PHP (`lang.php`), conservando los existentes (`docker`, `json`, `markdown`, `python`, `typescript`, `yaml`).
- R2. Configurar la integración para que Neovim / Mason instale y gestione automáticamente los LSPs, linters, árboles Tree-sitter y formatters asociados a cada lenguaje (jdtls, gopls, rust-analyzer, phpactor, @angular/language-server, vtsls).

**Navegación e Inteligencia de Código (LSP)**
- R3. Asegurar y visibilizar los atajos de salto de código: Ir a la Definición (`gd`), Ir a la Interfaz/Implementación (`gI`), e Ir a la Definición de Tipo (`gy`).
- R4. Proveer acceso inmediato a la ayuda contextual: Mostrar Ayuda / Hover de funciones y tipos con `K`, y abrir ventana flotante de diagnóstico/errores de la línea con `<leader>cd`.
- R5. Facilitar la aplicación de sugerencias y correcciones: sugerencias de autocompletado interactivas con `<C-Space>` y panel de acciones rápidas / correcciones sugeridas (Code Actions / QuickFix) con `<leader>ca`.
- R6. Simplificar la edición y documentación: alternar comentarios de código en una línea o bloque (`gcc` / `gc`) y generar comentarios de documentación estructurados (JSDoc, TSDoc, JavaDoc, Google docstrings) mediante `neogen` accesible con `<leader>cn`.
- R7. Renombrado seguro de símbolos: permitir renombrar variables, funciones o clases en todo el archivo/proyecto con `<leader>cr`.

**Búsqueda, Referencias y Reemplazo Visual**
- R8. Visualización de referencias y coincidencias: listar todas las referencias o usos del símbolo bajo el cursor con `gr`, y resaltar coincidencias en el buffer con `*`.
- R9. Habilitar el módulo oficial de `grug-far.nvim` (`lazyvim.plugins.extras.editor.grug-far`) en `config/nvim/lazyvim.json` para proveer una interfaz gráfica e interactiva de búsqueda y reemplazo en tiempo real en todo el proyecto.
- R10. Mapear atajos de alta frecuencia para `grug-far` bajo `<leader>s`: `<leader>sr` para Search & Replace global, y `<leader>sw` para abrir el panel precargando automáticamente la palabra bajo el cursor.

**Resolución de Conflictos y Ergonomía de Ventanas**
- R11. Eliminar la asignación conflictiva de `<leader>w` a `:w<CR>` en `config/nvim/lua/config/keymaps.lua`, restaurando el submenú nativo de LazyVim para gestión de Ventanas y Splits (`<leader>w`).
- R12. Estandarizar el guardado universal de archivos en `<C-s>` (Control + S) tanto en modo Normal como en modo Inserción (sin salir de editar).
- R13. Registrar y asegurar atajos visuales para Git bajo `<leader>g`: terminal flotante de Lazygit (`<leader>gg`), Git blame de línea (`<leader>gb`), y visor de cambios / diffs (`<leader>gd`).

**Etiquetado Amigable en Which-Key**
- R14. Configurar `which-key.nvim` en `config/nvim/lua/plugins/which-key.lua` con etiquetas descriptivas e intuitivas en español para que al presionar `<Space>` el usuario vea claramente:
  - `<leader>c` -> `+código (acciones, rename, format, doc)`
  - `<leader>g` -> `+git (lazygit, blame, diff)`
  - `<leader>s` -> `+buscar y reemplazar (grep, files, grug-far)`
  - `<leader>w` -> `+ventanas y divisiones (splits, resize)`
  - `<leader>b` -> `+pestañas y buffers`
  - `<leader>x` -> `+errores y diagnósticos (trouble)`
  - `<leader>u` -> `+opciones visuales (toggles)`

**Sincronización de Terminal (Fish) y Documentación**
- R15. Actualizar la función interactiva `guia` en `config/fish/functions/guia.fish` (en la vista general y en `guia nvim`), sincronizando:
  - Reemplazo de `<Space> + w` por `Ctrl + s` para guardar.
  - Inclusión de `<Space> + w` para Ventanas/Splits.
  - Inclusión de `gd` / `gI` (definición / implementación), `K` (ayuda hover), `<Space> + ca` (acciones y sugerencias), `<Space> + cd` (errores de línea), `gr` (referencias), y `<Space> + sr` / `<Space> + sw` (buscar/reemplazar con Grug-Far).
- R16. Actualizar `docs/neovim.md` y `docs/cheatsheet.md` con las tablas completas de atajos de código sincronizados, la guía de búsqueda y reemplazo visual, y las instrucciones de aprovisionamiento de SDKs con `mise` (`mise use -g java`, `go`, `rust`, etc.).

---

## Success Criteria

- Al abrir cualquier proyecto en Java, Go, Rust, Angular, PHP, Python o TypeScript, Neovim carga LSP, formato, linting y resaltado sintáctico sin pasos manuales adicionales.
- Presionar `gd` lleva directo a la definición; `gI` a la implementación; `K` abre la ventana flotante de ayuda/documentación.
- Presionar `<leader>ca` despliega el menú flotante con las correcciones sugeridas por el LSP y permite aplicarlas con `<Enter>`.
- Presionar `<leader>cn` genera automáticamente el docstring con parámetros y retornos correctos según el lenguaje.
- Presionar `<leader>sr` o `<leader>sw` abre el panel visual de Grug-far para reemplazar palabras con vista previa en vivo antes de escribir cambios en disco.
- Presionar `<leader>w` abre el menú de ventanas y divisiones sin guardar accidentalmente el archivo.
- Presionar `<C-s>` guarda el archivo de inmediato tanto mientras se escribe como en modo normal.
- El comando `guia` o `guia nvim` en la terminal Fish refleja exactamente los mismos atajos actualizados y sin discrepancias.
- Las guías `docs/neovim.md` y `docs/cheatsheet.md` están 100% alineadas con la configuración real.

---

## Scope Boundaries

- No se forzará la instalación de runtimes pesados (JDK 21, Rust toolchain, Go SDK, PHP CLI) dentro del instalador core `./omc install` ni en el `Brewfile` obligatorio; la gestión de SDKs se delega al usuario mediante `mise`.
- No se reemplazarán los atajos fundamentales de Vim modal (`hjkl`, `w`, `b`, `u`, `y`); se preserva el comportamiento idiomático de LazyVim para garantizar compatibilidad con actualizaciones upstream.
- La configuración no añadirá plugins redundantes para tareas que LazyVim o sus extras oficiales ya resuelven de forma nativa.

---

## Key Decisions

- **LazyVim Idiomático Pulido:** Mantener la convención de grupos de LazyVim y resolver colisiones en lugar de sobreescribir con esquemas tipo VS Code, asegurando estabilidad y soporte nativo.
- **Acciones LSP Nativas + Grug-far:** Centralizar la inteligencia de código en los atajos estándar enriquecidos con `which-key` descriptivo y `grug-far` para reemplazo global visual.
- **Sincronización Total (Triple Punto):** Garantizar consistencia estricta entre la configuración Lua de Neovim, el comando interactivo Fish (`guia`) y la documentación (`docs/neovim.md` + `docs/cheatsheet.md`).
- **Runtimes vía `mise`:** Centralizar las instrucciones de SDKs de sistema en `docs/neovim.md` aprovechando que `mise` ya forma parte del entorno de OhMyConfig.

---

## Dependencies / Assumptions

- Asume que Neovim 0.10+ y Homebrew están instalados (garantizado por OhMyConfig).
- Los extras de LazyVim dependen de que Mason pueda descargar binarios precompilados para macOS.
- El servidor `jdtls` (Java) requiere un runtime Java 17+ instalado en el sistema para poder ejecutarse.

---

## Outstanding Questions

### Resolve Before Planning
*(Ninguna pregunta bloqueante pendiente)*

### Deferred to Planning
- [Afecta R14][Técnico] Validar sintaxis de registro de grupos en Which-Key v3 (utilizar `spec` en el plugin de LazyVim para sobreescribir descripciones amigables en español sin romper bindings existentes).
- [Afecta R2][Técnico] Validar si `lang.angular` interactúa adecuadamente con `vtsls` y si se beneficia de snippets de Angular.

---

## Next Steps

-> `/ce-plan` para elaborar el plan detallado de implementación paso a paso.
