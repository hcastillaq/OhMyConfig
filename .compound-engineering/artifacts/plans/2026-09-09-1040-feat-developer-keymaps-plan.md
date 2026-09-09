---
title: "Developer-First Keymap Route for Neovim & Terminal Integration"
date: "2026-09-09"
artifact_contract: "ce-unified-plan/v1"
artifact_readiness: "implementation-ready"
product_contract_source: "ce-brainstorm"
execution: "code"
---

# Developer-First Keymap Route for Neovim & Terminal Integration

## Goal Capsule

### Objective
Crear una experiencia de edición intuitiva, explícita y de baja fricción en Neovim para desarrolladores acostumbrados a editores modernos como VSCode, optimizando las acciones cotidianas (búsqueda, reemplazo, portapapeles y código) mediante una taxonomía clara en el menú `<leader>` (Which-Key) y garantizando que ninguna combinación interfiera con Zellij, Fish Shell, Atuin o Ghostty en la terminal.

### Means
- Reestructurar los atajos de Neovim en `config/nvim/lua/config/keymaps.lua` y metadatos en `config/nvim/lua/plugins/which-key.lua` siguiendo la taxonomía de verbos: Buscar (`<leader>s`), Reemplazar (`<leader>r`) y Código (`<leader>c`).
- Configurar el portapapeles del sistema transparente en `config/nvim/lua/config/options.lua` y un mapeo de pegado seguro no destructivo.
- Habilitar `macos-option-as-alt = true` en `config/ghostty/config` para aislar limpiamente los atajos `Alt` de Zellij en macOS.
- Sincronizar y depurar `documentation/neovim.md`, `documentation/cheatsheet.md` y `README.md`.

### Authority Hierarchy
1. **Product Contract:** Preserva intacta la intención acordada en la fase de brainstorm.
2. **Planning Contract:** Gobierna las decisiones técnicas de implementación (KTDs) y la secuenciación de unidades (U-IDs).
3. **Implementation Units:** Gobierna los cambios concretos en archivos y escenarios de prueba.

### Stop Conditions
- Si alguna combinación propuesta colisiona con el manejo nativo de terminal en Ghostty o Zellij.
- Si las pruebas sintácticas de Lua (`nvim --headless`) o de compilación de VitePress fallan.

---

## Product Contract

### 1. Problem Statement & Background
En entornos de desarrollo en terminal sobre macOS, Neovim a menudo presenta una barrera de entrada cognitiva elevada en comparación con herramientas GUI como VSCode:
1. **Sobrecarga y ambigüedad de atajos:** Atajos vitales como búsqueda global, reemplazo de proyecto, correcciones rápidas y renombrado están dispersos en prefijos poco evidentes (`<leader>sr`, `<leader>/`, `<leader>co`, `<leader>cc`).
2. **Fricción del portapapeles:** En Vim clásico, borrar o reemplazar sobreescritura el registro por defecto, provocando que lo copiado se pierda tras un cambio menor.
3. **Colisiones inter-herramientas:** La convivencia de multiplexores (Zellij), shells interactivas (Fish con Atuin y FZF), emulador (Ghostty) y el editor requiere un deslinde tajante de modificadores y teclas para no secuestrar flujos de trabajo.

### 2. User Personas & Developer Experience
- **Desarrollador Fullstack / Backend / Frontend:** Trabaja intensamente editando código, buscando archivos por nombre, rastreando llamadas de funciones en todo el repo y refactorizando variables. Valora la inmediatez visual de Which-Key sin tener que memorizar combinaciones crípticas.
- **Usuario de Terminal Diaria:** Utiliza Zellij para dividir paneles (tests, logs, servidor) y Neovim en el panel principal; necesita pasar de un split a otro sin que el multiplexor intercepte las teclas del editor ni viceversa.

### 3. Key Decisions & Rationales

- **Taxonomía por Verbos de Intención:**
  - `s` $\rightarrow$ **Search / Buscar:** Archivos, texto global, símbolos, buffers.
  - `r` $\rightarrow$ **Replace / Reemplazar:** Reemplazo interactivo en proyecto (Grug-Far), en archivo con confirmación o palabra bajo cursor.
  - `c` $\rightarrow$ **Code / Acciones de Código:** Acciones de lenguaje (LSP code action, rename, format, docstrings).
  - `w` $\rightarrow$ **Windows / Ventanas:** Splits y layout.
  - `b` $\rightarrow$ **Buffers / Pestañas:** Gestión de buffers abiertos.
  - `g` $\rightarrow$ **Git:** Lazygit, diffs, blame y hunks.
  *(session-settled: user-directed — elegido sobre agrupar todo bajo Search o replicar atajos de VSCode con Ctrl)*

- **Portapapeles de Sistema Transparente:**
  - `vim.opt.clipboard = "unnamedplus"` integrado con el portapapeles de macOS.
  - Al pegar en modo visual (`p` o `<leader>p`), se evita que la selección eliminada contamine el registro principal.
  *(session-settled: user-directed — elegido sobre separación manual con registros de comillas dobles)*

- **Deslinde Estricto de Modificadores entre Herramientas:**
  - **Terminal / Ghostty:** Activar `macos-option-as-alt = true` para que Option emita secuencias Escape reales en macOS.
  - **Zellij (Multiplexor):** Monopolio sobre combinaciones con `Alt` (`Alt+h/j/k/l`, `Alt+n`, etc.).
  - **Neovim (Editor):** Monopolio sobre `Ctrl+h/j/k/l` para splits internos y tecla `<Space>` (Leader) para operaciones del IDE.
  - **Fish / FZF / Atuin (Shell):** Actúan en el prompt interactivo de la shell sin chocar con Neovim.

### 4. Functional Requirements

#### FR-1: Menú de Búsqueda (`<leader>s`)
- **FR-1.1:** `<leader>sf` o `<leader><Space>`: Buscar archivos en el proyecto (File picker).
- **FR-1.2:** `<leader>sg`: Búsqueda de texto en todo el proyecto (Live Grep).
- **FR-1.3:** `<leader>sw`: Búsqueda del texto/palabra bajo el cursor en todo el proyecto.
- **FR-1.4:** `<leader>ss`: Búsqueda de símbolos LSP (funciones, clases, interfaces) en el archivo.
- **FR-1.5:** `<leader>sS`: Búsqueda de símbolos en todo el workspace/proyecto.
- **FR-1.6:** `<leader>sb`: Selector difuso de buffers abiertos.
- **FR-1.7:** `<leader>s/`: Búsqueda difusa dentro del buffer actual.
- **FR-1.8:** `<leader>st`: Búsqueda de comentarios TODO/FIXME en el proyecto (Snacks/todo-comments).
- **FR-1.9:** `s` (modo normal): Salto instantáneo en pantalla vía Flash.

#### FR-2: Menú de Reemplazo (`<leader>r`)
- **FR-2.1:** `<leader>rp`: Abrir panel interactivo de Search & Replace en proyecto completo con Grug-Far (normal y visual).
- **FR-2.2:** `<leader>rw`: Pre-cargar palabra actual o selección en Grug-Far para reemplazo global inmediato.
- **FR-2.3:** `<leader>rb`: Reemplazo en el buffer/archivo actual con confirmación visual interactiva (`:%s///gc`).

#### FR-3: Menú de Código (`<leader>c`)
- **FR-3.1:** `<leader>ca`: Code Action / Quick Fix sugerido por LSP.
- **FR-3.2:** `<leader>cr`: Renombrar símbolo en todo el proyecto (LSP Rename).
- **FR-3.3:** `<leader>cf`: Formatear archivo activo con linter/formatter (Prettier, Stylua, Ruff).
- **FR-3.4:** `<leader>cn`: Generar docstring estructurado (JSDoc, Google, TSDoc) con Neogen (`<leader>cnc` clase, `<leader>cnt` tipo, `<leader>cnF` archivo).
- **FR-3.5:** `<leader>cd`: Diagnóstico y explicación flotante del error en la línea actual (`vim.diagnostic.open_float`, estándar de LazyVim).
- **FR-3.6:** `<leader>cx`: Abrir panel de diagnósticos y errores del proyecto (Trouble / Snacks diagnostics).
- **FR-3.7:** Liberar `<leader>cc` y `<leader>co` (tanto en modo normal como visual) de mapeos locales contradictorios para preservar CodeLens y Organize Imports nativos de LSP.

#### FR-4: Portapapeles y Edición Común
- **FR-4.1:** Mantener `Ctrl+s` universal para guardado rápido en modo normal e inserción (`keymaps.lua`).
- **FR-4.2:** Copiado nativo con `y` / `yy` / `yiw` conectado al clipboard del sistema vía `opt.clipboard = "unnamedplus"`.
- **FR-4.3:** Pegado sobre selección visual preservando el registro copiado sin desplazar cursor innecesariamente (`xmap p P`).
- **FR-4.4:** Mapeos de comentarios claros delegados a LazyVim/ts-comments: `gcc` (línea), `gc` (bloque visual).

#### FR-5: Descubribilidad & Which-Key
- **FR-5.1:** Etiquetas en español consistentes y descriptivas en `which-key.lua` con iconos limpios.
- **FR-5.2:** Delay de Which-Key calibrado a 200ms en `config/nvim/lua/plugins/which-key.lua` (`opts.delay = 200`).

### 5. Non-Goals & Boundaries
- **No reasignar los atajos nativos de Vim:** No se eliminarán comandos como `dd`, `dw`, `ciw`, `/`, `?`, `n`, `N` para no romper la fluidez de usuarios de Vim.
- **Git en segundo plano:** Las operaciones de Git se mantienen bajo `<leader>g` sin alterar su estabilidad actual.
- **No duplicar extensiones pesadas:** Se utilizarán las capacidades ya instaladas y empaquetadas en LazyVim (Snacks/fzf-lua, Grug-Far, Neogen, Blink.cmp).

---

## Planning Contract

### Key Technical Decisions (KTDs)

- **KTD-1: Delegación Inteligente a Snacks / fzf-lua en Búsquedas:**
  En LazyVim moderno, Snacks Picker o fzf-lua gestionan la búsqueda de archivos y texto (`Snacks.picker.files()`, `Snacks.picker.grep()`). En `keymaps.lua` mapearemos directamente las funciones de API de Snacks o LazyVim con fallback seguro a Telescope/fzf si estuviera presente, garantizando que `<leader>sf`, `<leader>sg`, `<leader>sw` y `<leader>sb` abran el picker oficial.
  *(session-settled: user-directed — unificar bajo `<leader>s`)*

- **KTD-2: Integración de Reemplazo en Proyecto con Grug-Far:**
  Grug-Far ya está configurado en LazyVim (`grug-far.nvim`). En lugar de depender únicamente del atajo legacy `<leader>sr`, crearemos el grupo `r` (Reemplazar):
  - `<leader>rp`: Ejecuta `require('grug-far').open()` o LazyVim helper.
  - `<leader>rw`: Abre Grug-Far con el término bajo el cursor pre-poblado (`require('grug-far').open({ prefills = { search = vim.fn.expand("<cword>") } })`).
  - `<leader>rb`: Mapea `:s/` interactivo para reemplazo en el archivo actual con confirmación.
  *(session-settled: user-directed — nuevo grupo semántico `<leader>r`)*

- **KTD-3: Desacoplamiento de Código, Diagnósticos y Docstrings:**
  - Eliminar los mapeos locales en `keymaps.lua` que forzaban `<leader>cc` a comentar (tanto en normal como en visual) y `<leader>co` a jumplist.
  - Preservar `<leader>cd` para la función estándar de LazyVim: diagnóstico de línea flotante (`vim.diagnostic.open_float`).
  - Mantener `<leader>cn` (y subcomandos `cnc`, `cnt`, `cnF`) para docstrings de Neogen, documentándolo explícitamente en Which-Key.
  - Mapear explícitamente `<leader>cx` en `keymaps.lua` para abrir el panel de diagnósticos del proyecto (delegando a `Trouble diagnostics toggle` o `Snacks.picker.diagnostics()`).
  - Mantener `<leader>ca` (`vim.lsp.buf.code_action`), `<leader>cr` (`vim.lsp.buf.rename`), `<leader>cf` (`LazyVim.format`).
  *(session-settled: user-approved — resolver colisiones de LSP, diagnósticos y comentarios)*

- **KTD-4: Configuración de Portapapeles macOS y Pegado No Destructivo:**
  - En `config/nvim/lua/config/options.lua`, asegurar `vim.opt.clipboard = "unnamedplus"`.
  - En `config/nvim/lua/config/keymaps.lua`, agregar `vim.keymap.set("x", "p", "P", { desc = "Pegar sin sobreescribir portapapeles" })` (uso canónico de `P` en modo visual que evita saltos indeseados de cursor y preserva el registro).

- **KTD-5: Garantía de Alt Terminal en Ghostty:**
  - En `config/ghostty/config`, agregar `macos-option-as-alt = true`. Esto asegura que al presionar Option en teclados Mac se emita `Esc+` y Zellij reciba `Alt+hjkl` limpiamente sin requerir configuraciones periféricas extrañas.

---

## High-Level Technical Design

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        MAPA DE CAPAS Y DOMINIOS                        │
├───────────────────┬──────────────────────────────────┬─────────────────┤
│ Terminal / Ghostty│ macos-option-as-alt = true       │ Emite Alt real  │
├───────────────────┼──────────────────────────────────┼─────────────────┤
│ Multiplexor Zellij│ Alt + h/j/k/l, Alt + n, Alt + [  │ Paneles & Tabs  │
├───────────────────┼──────────────────────────────────┼─────────────────┤
│ Shell (Fish/Atuin)│ Ctrl + r (Atuin), Ctrl + t (FZF) │ Historial/Prompt│
├───────────────────┼──────────────────────────────────┼─────────────────┤
│ Editor Neovim     │ Ctrl + h/j/k/l (Splits internos) │ Navegación Nvim │
│                   │ Ctrl + s (Guardar)               │ Save universal  │
│                   │ <Space> (Leader Menu):           │                 │
│                   │   ├── s -> Buscar (Search)       │ Picker / Grep   │
│                   │   ├── r -> Reemplazar (Replace)  │ Grug-Far TUI    │
│                   │   ├── c -> Código (LSP / Docs)   │ Fix, Rename, Doc│
│                   │   ├── w -> Ventanas (Splits)     │ Split controls  │
│                   │   ├── b -> Buffers (Pestañas)    │ Tab controls    │
│                   │   └── g -> Git (Lazygit / Diff)  │ Git integration │
└───────────────────┴──────────────────────────────────┴─────────────────┘
```

---

## Implementation Units

### U1. Configurar Portapapeles de Sistema y Ghostty Option-as-Alt
**Goal:** Garantizar que el portapapeles del sistema sea transparente y que la terminal envíe teclas `Alt` fiables a Zellij sin tocar atajos de Neovim.  
**Requirements:** FR-4.1, FR-4.2, FR-4.3, KTD-4, KTD-5.  
**Dependencies:** Ninguna.  
**Files:**
- `config/ghostty/config`
- `config/nvim/lua/config/options.lua`
- `config/nvim/lua/config/keymaps.lua`

**Approach:**
1. Editar `config/ghostty/config` y agregar `macos-option-as-alt = true`.
2. Verificar que `config/nvim/lua/config/options.lua` contenga `opt.clipboard = "unnamedplus"`.
3. En `config/nvim/lua/config/keymaps.lua`:
   - Mantener `Ctrl+s` universal para guardar en normal, inserción y visual (`FR-4.1`).
   - Agregar el mapeo canónico de modo visual para pegado seguro sin perder el registro:
     `vim.keymap.set("x", "p", "P", { desc = "Pegar sin sobreescribir portapapeles" })`.

**Test Scenarios:**
- Copiar una línea con `yy`, seleccionar otra palabra en modo visual, presionar `p`. Verificar que la palabra original copiada sigue disponible para pegarse de nuevo con `p` y que el cursor queda posicionado al final del pegado.
- Validar que Ghostty conserve sintaxis válida sin errores de parseo.

**Verification:**
`nvim --headless +"lua require('config.options')" +"lua require('config.keymaps')" +q` sin errores.

---

### U2. Reestructurar Grupo de Búsqueda (`<leader>s`) en Neovim
**Goal:** Definir explícitamente los atajos de búsqueda intuitivos para desarrolladores bajo `<leader>s`.  
**Requirements:** FR-1.1 a FR-1.9, KTD-1.  
**Dependencies:** U1.  
**Files:**
- `config/nvim/lua/config/keymaps.lua`
- `config/nvim/lua/plugins/which-key.lua`

**Approach:**
1. Mapear en `keymaps.lua`:
   - `<leader>sf`: Búsqueda de archivos (`LazyVim.pick("files")` o `Snacks.picker.files()`).
   - `<leader>sg`: Live grep de texto en todo el proyecto (`LazyVim.pick("live_grep")` o `Snacks.picker.grep()`).
   - `<leader>sw`: Búsqueda de palabra bajo el cursor en proyecto (`LazyVim.pick("grep_word")` o `Snacks.picker.grep_word()`).
   - `<leader>ss`: Símbolos del documento actual (`LazyVim.pick("lsp_symbols")` o `Snacks.picker.lsp_symbols()`).
   - `<leader>sS`: Símbolos en todo el proyecto (`LazyVim.pick("lsp_workspace_symbols")`).
   - `<leader>sb`: Buffers abiertos (`LazyVim.pick("buffers")`).
   - `<leader>s/`: Buscar en buffer actual (`LazyVim.pick("lines")` o `Snacks.picker.lines()`).
   - `<leader>st`: Buscar comentarios TODO (`LazyVim.pick("todo")` o `Snacks.picker.todo_comments()`).
2. En `which-key.lua`, actualizar el registro del grupo `s`: `{ "<leader>s", group = "buscar", icon = " " }`.

**Test Scenarios:**
- Presionar `<Space>s` en Neovim y verificar que Which-Key despliega el menú con etiquetas claras (`sf`, `sg`, `sw`, `ss`, `sS`, `sb`, `s/`, `st`).
- Ejecutar `<Space>sf` y verificar que abre el selector de archivos del proyecto.
- Ejecutar `<Space>sg` y verificar búsqueda de texto reactiva.

**Verification:**
Ejecución headless de Neovim validando que los mapeos existen en la tabla `vim.fn.maparg("<leader>sf", "n")`.

---

### U3. Implementar Grupo de Reemplazo (`<leader>r`) en Neovim
**Goal:** Proveer una experiencia de reemplazo global e individual ergonómica similar a VSCode con Grug-Far y comandos de buffer.  
**Requirements:** FR-2.1 a FR-2.3, KTD-2.  
**Dependencies:** U2.  
**Files:**
- `config/nvim/lua/config/keymaps.lua`
- `config/nvim/lua/plugins/which-key.lua`

**Approach:**
1. En `keymaps.lua`:
   - `<leader>rp`: Reemplazo interactivo en proyecto con Grug-Far en modo normal y modo visual:
     ```lua
     vim.keymap.set({ "n", "v" }, "<leader>rp", function()
       local grug = require("grug-far")
       grug.open()
     end, { desc = "Reemplazar en proyecto (Grug-Far)" })
     ```
   - `<leader>rw`: Reemplazo con palabra pre-cargada (normal) o texto seleccionado (visual):
     ```lua
     vim.keymap.set("n", "<leader>rw", function()
       require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
     end, { desc = "Reemplazar palabra actual en proyecto" })

     vim.keymap.set("v", "<leader>rw", function()
       require("grug-far").with_visual_selection()
     end, { desc = "Reemplazar selección actual en proyecto" })
     ```
   - `<leader>rb`: Reemplazo en buffer con confirmación visual:
     ```lua
     vim.keymap.set("n", "<leader>rb", ":%s///gc<Left><Left><Left><Left>", { desc = "Reemplazar en archivo actual (confirmar)" })
     vim.keymap.set("v", "<leader>rb", ":s///gc<Left><Left><Left><Left>", { desc = "Reemplazar en selección (confirmar)" })
     ```
2. En `which-key.lua`, registrar el grupo `r`: `{ "<leader>r", group = "reemplazar", icon = " " }`.

**Test Scenarios:**
- Presionar `<Space>r` y verificar que Which-Key lista `rp`, `rw`, `rb` en normal y visual.
- Invocar `<leader>rw` sobre una función y constatar que Grug-Far abre con el nombre cargado listo para ingresar el nuevo término.
- Seleccionar un bloque en visual y presionar `<leader>rb`, verificando que se inserta `:'<,'>s///gc` con el cursor centrado.

**Verification:**
Verificación en Neovim headless de la presencia de las combinaciones bajo `<leader>r`.

---

### U4. Limpiar y Consolidar Grupo de Código (`<leader>c`) y Deshacer Conflictos
**Goal:** Eliminar colisiones entre comentarios/LSP y consolidar las acciones de refactorización y diagnósticos.  
**Requirements:** FR-3.1 a FR-3.7, FR-4.4, KTD-3.  
**Dependencies:** U3.  
**Files:**
- `config/nvim/lua/config/keymaps.lua`
- `config/nvim/lua/plugins/which-key.lua`

**Approach:**
1. En `keymaps.lua`:
   - Retirar los mapeos locales conflictivos:
     - `vim.keymap.set("n", "<leader>cc", ...)` y `vim.keymap.set("v", "<leader>cc", ...)` (removidos para no bloquear CodeLens de LSP ni interferir con `gcc`/`gc`).
     - `vim.keymap.set("n", "<leader>co", ...)` (removido para no bloquear Organize Imports de LSP).
     - `vim.keymap.set("n", "<leader>bl", ...)` y `vim.keymap.set("n", "<leader>bh", ...)` (retirados para no chocar con las acciones de Bufferline; la navegación entre buffers usa `Shift+l` y `Shift+h`, o `]b` y `[b`).
   - Mapear explícitamente el panel de diagnósticos del proyecto:
     ```lua
     vim.keymap.set("n", "<leader>cx", function()
       if pcall(require, "trouble") then
         vim.cmd("Trouble diagnostics toggle")
       else
         LazyVim.pick("diagnostics")()
       end
     end, { desc = "Panel de errores y diagnósticos" })
     ```
2. En `which-key.lua`:
   - Calibrar el delay de Which-Key a 200ms (`opts.delay = 200`) para respuesta rápida (`FR-5.2`).
   - Asegurar que el grupo `c` tenga etiquetas nítidas:
     - `<leader>ca`: "Acciones de código / Quick Fix"
     - `<leader>cr`: "Renombrar símbolo en todo el proyecto"
     - `<leader>cf`: "Formatear archivo"
     - `<leader>cd`: "Ver explicación del error de la línea"
     - `<leader>cn`: "Generar docstring (Neogen)"
     - `<leader>cx`: "Panel de errores y diagnósticos"

**Test Scenarios:**
- Abrir un buffer con LSP y verificar que `<leader>ca` abre el menú de acciones de código.
- Verificar que `<leader>cd` muestra el diagnóstico de línea flotante nativo de LazyVim.
- Verificar que `<leader>cn` genera docstrings con Neogen.
- Verificar que `<leader>cx` abre Trouble o el picker de diagnósticos.
- Constatar que `gcc` y `gc` siguen funcionando nativamente para comentar líneas sin requerir `<leader>cc`.

**Verification:**
Comprobar que no existen advertencias de mapeos duplicados en `:checkhealth which-key`.

---

### U5. Sincronizar Documentación, Cheatsheet y Guías
**Goal:** Mantener la verdad única en la documentación del repositorio reflejando la nueva ruta de atajos sin omisiones ni discrepancias.  
**Requirements:** FR-5.1.  
**Dependencies:** U1, U2, U3, U4.  
**Files:**
- `documentation/neovim.md`
- `documentation/cheatsheet.md`
- `README.md`

**Approach:**
1. Actualizar `documentation/neovim.md`:
   - Reemplazar tablas de búsqueda y reemplazo con la nueva estructura `<leader>s*` y `<leader>r*`.
   - Documentar el grupo `<leader>c*` con Quick Fix (`ca`), Rename (`cr`), Formato (`cf`), Diagnóstico de línea (`cd`) y Neogen (`cn`).
   - Explicar el comportamiento del portapapeles transparente (`unnamedplus` y pegado seguro con `P`).
2. Actualizar `documentation/cheatsheet.md`:
   - Reflejar exactamente la nueva taxonomía por verbos.
   - Clarificar los roles de Ghostty (Option como Alt), Zellij (Alt), Shell (Ctrl) y Neovim (Ctrl + Leader).
3. Actualizar sección de atajos rápidos en `README.md`.
4. Ejecutar compilación de prueba con VitePress para asegurar cero errores de build y enlaces rotos.

**Test Scenarios:**
- Ejecutar build de VitePress con `npx vitepress build`.
- Verificar que todos los atajos listados en `cheatsheet.md` coinciden al 100% con los configurados en Neovim.

**Verification:**
`npm install --no-save --ignore-scripts vitepress vue @vue/server-renderer && npx vitepress build`.

---

## Verification Contract

### Comandos de Validación
1. **Sintaxis y Mapeos de Neovim:**
   ```bash
   nvim --headless +"lua require('config.options')" +"lua require('config.keymaps')" +q
   ```
2. **Chequeo de Configuración de Ghostty:**
   ```bash
   grep "macos-option-as-alt" config/ghostty/config
   ```
3. **Compilación de Documentación con VitePress:**
   ```bash
   npm install --no-save --ignore-scripts vitepress vue @vue/server-renderer && npx vitepress build
   ```
4. **Verificación de Git Diff:**
   ```bash
   git diff --check
   ```

---

## Definition of Done

- [ ] Todas las unidades de implementación U1 a U5 están completadas y probadas.
- [ ] Ghostty tiene `macos-option-as-alt = true` habilitado.
- [ ] Neovim cuenta con portapapeles del sistema sin pérdida al sobre-pegar.
- [ ] Menús de Which-Key (`<leader>s`, `<leader>r`, `<leader>c`, `<leader>w`, `<leader>b`, `<leader>g`) son intuitivos y 100% funcionales.
- [ ] No existen sobrecargas destructivas (`<leader>cc`, `<leader>co`, `<leader>bl`).
- [ ] Documentación sincronizada y build de VitePress exitoso con 0 errores.
