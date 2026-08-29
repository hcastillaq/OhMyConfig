# ⚡ OhMyConfig

Entorno de desarrollo moderno, minimalista y de alto rendimiento para **macOS** configurado con utilidades de última generación escritas en **Rust** y **Go**, con una estética unificada bajo la paleta **Tokyonight Night** y glifos **Nerd Font v3**.

---

## 📑 Tabla de Contenidos

1. [🚀 Instalación Rápida & Idempotente](#-instalación-rápida--idempotente)
2. [👑 GUÍA MAESTRA DE GIT Y CONTROL DE VERSIONES (PRIORIDAD)](#-guía-maestra-de-git-y-control-de-versiones-prioridad)
   - [2.1 Flujo de Trabajo en Terminal y Atajos Esenciales](#21-flujo-de-trabajo-en-terminal-y-atajos-esenciales)
   - [2.2 Visualización de Historial y Árbol de Commits (`gl`, `glog`, `glp`)](#22-visualización-de-historial-y-árbol-de-commits-gl-glog-glp)
   - [2.3 Interfaz Visual Interactiva con Lazygit (`lg`)](#23-interfaz-visual-interactiva-con-lazygit-lg)
   - [2.4 Paginador y Resaltado de Diffs con Git-Delta](#24-paginador-y-resaltado-de-diffs-con-git-delta)
   - [2.5 Radiografía de Repositorios con Onefetch (`of`)](#25-radiografía-de-repositorios-con-onefetch-of)
   - [2.6 Integración Remota con GitHub CLI (`gh`)](#26-integración-remota-con-github-cli-gh)
   - [2.7 Refactorización Rápida en Repositorios (`rg` + `sd` + `fd`)](#27-refactorización-rápida-en-repositorios-rg--sd--fd)
3. [🛠️ GUÍA MAESTRA DE NEOVIM (EDITOR PRINCIPAL)](#️-guía-maestra-de-neovim-editor-principal)
   - [3.1 Conceptos Fundamentales: Modos y Tecla Leader](#31-conceptos-fundamentales-modos-y-tecla-leader)
   - [3.2 Moverse por el Código a Máxima Velocidad](#32-moverse-por-el-código-a-máxima-velocidad)
   - [3.3 Ventanas, Splits y Explorador de Archivos](#33-ventanas-splits-y-explorador-de-archivos)
   - [3.4 Pestañas Superiores (Buffers), Guardado y Deshacer](#34-pestañas-superiores-buffers-guardado-y-deshacer)
   - [3.5 Copiar, Cortar, Pegar y Portapapeles de macOS](#35-copiar-cortar-pegar-y-portapapeles-de-macos)
   - [3.6 Búsqueda y Reemplazo (En Archivo y Todo el Proyecto)](#36-búsqueda-y-reemplazo-en-archivo-y-todo-el-proyecto)
   - [3.7 Inteligencia de Código (LSP) y Autocompletado](#37-inteligencia-de-código-lsp-y-autocompletado)
   - [3.8 Documentación Automática, Comentarios y Envolturas](#38-documentación-automática-comentarios-y-envolturas)
   - [3.9 GitLens y Control de Cambios en Vivo](#39-gitlens-y-control-de-cambios-en-vivo)
   - [3.10 Activación Dinámica de Lenguajes y Plugins (LazyExtras)](#310-activación-dinámica-de-lenguajes-y-plugins-lazyextras)
4. [🖥️ Terminal, Shell y Prompt](#️-terminal-shell-y-prompt)
5. [🪟 Multiplexor de Terminal (Zellij + zjstatus)](#-multiplexor-de-terminal-zellij--zjstatus)
6. [🔍 Navegación Inteligente y Búsqueda Difusa](#-navegación-inteligente-y-búsqueda-difusa)
7. [🌐 APIs, Datos y JSON](#-apis-datos-y-json)
8. [📊 Monitoreo, Procesos y Contenedores](#-monitoreo-procesos-y-contenedores)
9. [⚡ Tabla Maestra de Alias y Atajos](#-tabla-maestra-de-alias-y-atajos)

---

## 🚀 Instalación Rápida & Idempotente

El script `install.sh` automatiza la instalación de herramientas vía Homebrew y el despliegue seguro de configuraciones en `~/.config/`:

* **Copia Segura (Por Defecto):** Compara los archivos existentes; si detecta modificaciones previas, genera un respaldo automático (`.bak_YYYYMMDD_HHMMSS`) antes de escribir.
* **Modo Enlaces Simbólicos (`--link` o `-l`):** Enlaza `~/.config/` directamente a este repositorio para desarrollo activo de dotfiles.

```bash
# Opción A: Despliegue seguro con respaldos
chmod +x install.sh
./install.sh

# Opción B: Modo Symlinks directos
./install.sh --link
```

---

## 👑 GUÍA MAESTRA DE GIT Y CONTROL DE VERSIONES (PRIORIDAD)

OhMyConfig integra un stack completo para Git donde la terminal rápida, el motor de diffs visuales, el navegador interactivo y las herramientas de refactorización cooperan armónicamente.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        FLUJO INTEGRADO DE GIT                          │
├──────────────────┬──────────────────┬─────────────────┬────────────────┤
│   TERMINAL CLI   │    TUI VISUAL    │   DIFFS DELTA   │   TELEMETRÍA   │
│ g, gs, gc, gl, gd│  lazygit (`lg`)  │   git-delta     │ onefetch (`of`)│
└──────────────────┴──────────────────┴─────────────────┴────────────────┘
```

---

### 2.1 Flujo de Trabajo en Terminal y Atajos Esenciales

Para operaciones ultrarrápidas tenés atajos memorables configurados en Fish Shell:

| Atajo | Comando Real | Propósito / Caso de Uso |
| :--- | :--- | :--- |
| `gs` | `git status` | Ver estado de archivos (staged, unstaged, untracked). |
| `gaa` | `git add .` | Agregar todos los cambios al staging area. |
| `gc` | `git commit` | Abrir el editor para redactar un commit estructurado. |
| `gch <branch>` | `git checkout <branch>` | Cambiar de rama o restaurar archivos de trabajo. |
| `gd` | `git diff` | Ver cambios pendientes con resaltado de sintaxis **Delta**. |
| `gp` | `git push` | Subir la rama activa al repositorio remoto. |
| `g` | `git` | Acceso directo al binario de Git. |

---

### 2.2 Visualización de Historial y Árbol de Commits (`gl`, `glog`, `glp`)

Visualizá la historia de tu repositorio sin salir de la consola con formato **Tokyonight**:

#### **`gl` — Árbol de commits de la rama actual**
Muestra el grafo de bifurcación, hash corto en azul (`#7aa2f7`), referencias de ramas/tags en púrpura (`#bb9af7`), mensaje en blanco, tiempo relativo en gris y autor en cyan.
```bash
gl
```

#### **`glog` — Árbol completo de todas las ramas**
Incluye todas las ramas locales y remotas (`--all`) para entender cómo convergen los merges y rebases.
```bash
glog
```

#### **`glp` — Historial detallado con diffs en Delta**
Recorre los commits mostrando el diff completo de código línea por línea con resaltado de sintaxis.
```bash
glp
```

---

### 2.3 Interfaz Visual Interactiva con Lazygit (`lg`)

**Lazygit** es la herramienta central cuando un flujo de Git requiere granularidad visual (hacer staging de líneas sueltas, resolver conflictos o editar commits pasados).

```bash
lg
```

```
┌─────────┬───────────────────────────────┬──────────────────────────────┐
│ [1]     │ [3] Branches                  │ [Main Panel]                 │
│ Status  │ * main                        │                              │
├─────────┤   feature/auth                │ Diff enriquecido con Delta   │
│ [2]     ├───────────────────────────────┤ y opciones de navegación     │
│ Files   │ [4] Commits                   │                              │
│ [x] src │ * 008e985 feat: add layout    │                              │
└─────────┴───────────────────────────────┴──────────────────────────────┘
```

#### Atajos Clave en Lazygit:
* **Navegación entre paneles:** Teclas `1`, `2`, `3`, `4`, `5` o `Tab` / `Shift+Tab`.
* **Staging de líneas individuales:**
  1. En el panel **[2] Files**, presioná `Enter` sobre un archivo modificado.
  2. Navegá por los bloques (*hunks*) con `[` y `]`.
  3. Presioná `Espacio` en las líneas exactas que querés agregar al commit.
  4. Presioná `Esc` y luego `c` para commitear solo esas líneas.
* **Manejo de Ramas (Panel [3]):**
  * `Espacio` -> Checkout de la rama seleccionada.
  * `n` -> Crear nueva rama a partir de la actual.
  * `F` -> Fast-forward / Pull de la rama remota.
  * `M` -> Merge interactivo de la rama seleccionada en la activa.
* **Edición de Historial (Panel [4]):**
  * `s` -> Squash (combinar commit hacia abajo).
  * `r` -> Renombrar mensaje de commit (*reword*).
  * `d` -> Descartar commit (*drop*).
  * `e` -> Editar commit (*rebase interactive*).

---

### 2.4 Paginador y Resaltado de Diffs con Git-Delta

**Git-Delta** se integra de forma **no destructiva** en tu entorno mediante un archivo modular (`~/.config/git/delta.gitconfig`) enlazado con `include.path`. Esto garantiza que tus datos personales (`user.name`, `user.email`, claves GPG/SSH) se mantengan **100% intactos** en tu `~/.gitconfig`:

* **Resaltado por palabra:** Identifica exactamente qué caracteres cambiaron dentro de una misma línea modificada.
* **Paleta Tokyonight integrada:** Fondos oscuros no invasivos (`#3b222c` para eliminaciones, `#1c333b` para inserciones) y números de línea coloreados (`#f7768e` / `#9ece6a`).
* **Modo Side-by-Side (Opcional):**
  ```bash
  git diff | delta --side-by-side
  ```

---

### 2.5 Radiografía de Repositorios con Onefetch (`of`)

Obtené un resumen visual inmediato de cualquier repositorio al clonarlo o ingresar a él:

```bash
of
```
* Muestra el porcentaje de código por lenguaje con barras coloreadas.
* Cantidad total de commits, ramas, autores principales y antigüedad del repo.
* Detección automática de licencia (`MIT`, `Apache-2.0`, etc.) y tamaño en disco.
* Renderizado del logo en arte ASCII del lenguaje predominante.

---

### 2.6 Integración Remota con GitHub CLI (`gh`)

Gestioná el ciclo de vida remoto en GitHub sin abrir el navegador:

```bash
# Crear un Pull Request interactivo con título y descripción guiada
gh pr create

# Listar PRs abiertos del repositorio
gh pr list

# Descargar y colocarse directamente en la rama de un PR abierto
gh pr checkout 42

# Ver el estado de las revisiones y CI/CD de tu PR actual
gh pr status

# Clonar repositorios rápidamente
gh repo clone organizacion/repositorio
```

---

### 2.7 Refactorización Rápida en Repositorios (`rg` + `sd` + `fd`)

Combiná las utilidades en Rust para realizar cambios masivos seguros en todo el código:

1. **Buscar ocurrencias con Ripgrep (`rg`):**
   ```bash
   rg "API_URL_LEGACY"
   ```
2. **Reemplazar masivamente en archivos con `sd`:**
   ```bash
   # Sintaxis directa sin los problemas de sed en macOS
   sd 'https://api-v1.internal' 'https://api-v2.internal' src/**/*.ts
   ```
3. **Buscar archivos y ejecutar transformaciones con `fd`:**
   ```bash
   fd -e json -x prettier --write {}
   ```

---


## 🛠️ GUÍA MAESTRA DE NEOVIM (EDITOR PRINCIPAL)

OhMyConfig utiliza el motor de **LazyVim** con configuración modular en Lua, paleta **Tokyonight Night** y transparencia adaptativa para Ghostty. Esta guía está ordenada por **intenciones de uso real** para aprenderlo de forma progresiva.

```
config/nvim/
├── init.lua                      # Entrada principal (Bootstrap de LazyVim)
├── lazyvim.json                  # Registro de módulos/lenguajes activos (LazyExtras)
└── lua/
    ├── config/
    │   ├── options.lua           # Opciones nativas (números híbridos, undo persistente, tabs)
    │   ├── keymaps.lua           # Atajos de navegación, splits y gestión visual
    │   ├── autocmds.lua          # Eventos y hooks personalizados
    │   └── lazy.lua              # Bootstrap de LazyVim y carga de módulos
    └── plugins/
        ├── colorscheme.lua       # Tema Tokyonight Night con transparencia adaptativa
        ├── neo-tree.lua          # Símbolos limpios de estado de Git en el explorador
        └── neogen.lua            # Generador de docstrings estructurados (JSDoc, TSDoc, LuaDoc)
```

---

### 3.1 Conceptos Fundamentales: Modos y Tecla Leader

Neovim es un **editor modal**. No escribís todo el tiempo como en un procesador de texto; cambiás de modo según lo que quieras hacer:

```
┌────────────────────────────────────────────────────────────────────────┐
│                          LOS 4 MODOS CLAVE                             │
├──────────────────┬──────────────────┬─────────────────┬────────────────┤
│  NORMAL (<Esc>)  │   INSERT (`i`)   │  VISUAL (`v`)   │  COMANDO (`:`) │
│ Navegación, corte│ Escritura de     │ Selección de    │ Guardar (:w),  │
│ y comandos rápidos│ texto estándar   │ texto y bloques │ salir (:q), etc│
└──────────────────┴──────────────────┴─────────────────┴────────────────┘
```

* **Abrir Neovim:** Tipeá `v` o `v <archivo>` en la terminal.
* **Tecla `<leader>`:** Es la **barra espaciadora** (`<Space>`). Al presionarla en modo normal, tras 200 ms se abre el menú emergente **Which-Key** recordándote todas las opciones.
* **Regla de Oro:** Siempre que termines de escribir, presioná **`<Esc>`** para volver al **Modo Normal**.

---

### 3.2 Moverse por el Código a Máxima Velocidad

| Qué querés hacer | Atajo en Modo Normal | Explicación |
| :--- | :--- | :--- |
| **Moverse 1 posición** | **`h`** / **`j`** / **`k`** / **`l`** | Izquierda (`h`), Abajo (`j`), Arriba (`k`), Derecha (`l`) |
| **Saltar de palabra en palabra** | **`w`** / **`b`** | Siguiente palabra (`w`), Palabra anterior (`b`) |
| **Ir al inicio / fin de la línea** | **`0`** / **`$`** (o `^` / `$`) | `0` primer carácter, `$` final de línea |
| **Ir al inicio / fin del archivo** | **`gg`** / **`G`** | `gg` primera línea, `G` última línea del archivo |
| **Saltar N líneas con números relativos** | **`5j`**, **`12k`**, etc. | Mirás el número relativo en el margen izquierdo y saltás exacto |
| **SALTO INSTANTÁNEO EN PANTALLA (Flash)** | **`s`** + 2 letras + tecla guía | Saltás a cualquier palabra que veas en el monitor en 1 milisegundo |
| **Selección incremental por código** | **`Ctrl + Space`** | Expande la selección: variable $\rightarrow$ línea $\rightarrow$ función $\rightarrow$ clase |

---

### 3.3 Ventanas, Splits y Explorador de Archivos

| Qué querés hacer | Atajo | Explicación |
| :--- | :--- | :--- |
| **Abrir / Ocultar Explorador de Archivos** | **`<Space> + e`** | Abre el panel lateral resaltando el archivo actual |
| **Ver Estado de Git en el Explorador** | **`<Space> + ge`** | Abre el árbol mostrando solo archivos modificados |
| **Moverse al panel izquierdo (Explorador)** | **`Ctrl + h`** | Cambia el foco del código al explorador lateral |
| **Moverse al panel derecho (Editor)** | **`Ctrl + l`** | Vuelve del explorador al código |
| **Moverse a panel inferior / superior** | **`Ctrl + j`** / **`Ctrl + k`** | Navega entre ventanas divididas horizontalmente |
| **Redimensionar paneles** | **`Ctrl + Flechas`** | Ajusta el ancho o alto de la ventana activa |

#### Atajos rápidos DENTRO del Explorador de Archivos:
* **`l`** o **`<Enter>`**: Abre el archivo (o entra a una carpeta).
* **`h`**: Cierra/contrae la carpeta.
* **`a`**: Crear nuevo archivo o carpeta (terminar con `/` para carpeta).
* **`d`**: Borrar archivo/carpeta | **`r`**: Renombrar | **`c`** / **`m`**: Copiar / Mover.
* **`P`**: Vista previa flotante | **`H`**: Mostrar ocultos (`.dotfiles`) | **`?`**: Ayuda completa.

#### Íconos de Estado de Git en el Árbol de Archivos:
| Ícono | Estado en Git | Significado |
| :---: | :--- | :--- |
| **`?`** | **Untracked** | Archivo nuevo que todavía no agregaste con `git add` |
| **`●`** | **Unstaged** | Archivo con modificaciones pendientes de staging |
| **`✓`** | **Staged** | Archivo agregado al staging (`git add`) listo para commit |
| **`+`** | **Added** | Archivo recién creado y agregado al staging |
| **`➜`** | **Renamed** | Archivo renombrado |
| **`✖`** | **Deleted** | Archivo borrado |
| **`◌`** | **Ignored** | Archivo ignorado por `.gitignore` |
| **`⚡`** | **Conflict** | Conflicto de merge pendiente de resolución |

---

### 3.4 Pestañas Superiores (Buffers), Guardado y Deshacer

| Qué querés hacer | Atajo / Comando | Explicación |
| :--- | :--- | :--- |
| **Guardar archivo actual** | **`<Space> + w`** (o `:w`) | Guarda los cambios en disco |
| **Cerrar pestaña/buffer actual limpiamente** | **`<Space> + bd`** | Cierra el archivo sin dejar pestañas `[No Name]` |
| **Cerrar todas las demás pestañas** | **`<Space> + bo`** | Cierra todos los buffers excepto el que estás editando |
| **Siguiente / Anterior pestaña** | **`Shift + l`** / **`Shift + h`** | Navega por la barra de pestañas superior |
| **Elegir pestaña interactivamente** | **`<Space> + bp`** | Teclas guía para saltar a cualquier pestaña abierta |
| **Cerrar ventana / split** | **`<Space> + q`** (o `:q`) | Cierra la ventana activa |
| **DESHACER (Undo Persistente)** | **`u`** | Deshace el cambio (incluso tras apagar la PC) |
| **REHACER (Redo)** | **`Ctrl + r`** | Rehace el cambio deshecho |
| **Descartar cambios y recargar** | **`:e!`** | Vuelve a leer el archivo desde el disco |
| **Salir de Neovim descartando todo** | **`:qa!`** | Cierra todas las ventanas sin guardar |

---

### 3.5 Copiar, Cortar, Pegar y Portapapeles de macOS

> 🌐 **Sincronización Total:** Gracias a `clipboard = "unnamedplus"`, todo lo que copies con `y` queda en el portapapeles de macOS (`Cmd + V` en Chrome/Slack), y lo que copies afuera con `Cmd + C` se pega en Neovim con `p`.

| Acción | Modo Normal | Modo Visual (`v`) |
| :--- | :--- | :--- |
| **Copiar toda la línea** | **`yy`** | — |
| **Copiar la palabra actual** | **`yiw`** (*Yank Inside Word*) | — |
| **Copiar bloque o párrafo** | **`yap`** (*Yank Around Paragraph*) | — |
| **Copiar texto seleccionado** | — | Seleccioná y tocá **`y`** |
| **Cortar / Borrar toda la línea** | **`dd`** | — |
| **Cortar / Borrar palabra actual** | **`diw`** | — |
| **Cortar texto seleccionado** | — | Seleccioná y tocá **`d`** |
| **Pegar después del cursor** | **`p`** | — |
| **Pegar antes del cursor** | **`P`** | — |
| **Reemplazar selección pegando** | — | Seleccioná texto y tocá **`p`** (pegado seguro) |

---

### 3.6 Búsqueda y Reemplazo (En Archivo y Todo el Proyecto)

#### A. Buscar dentro del archivo actual
* **`/palabra` + `<Enter>`**: Buscar hacia adelante | **`?palabra` + `<Enter>`**: Buscar hacia atrás.
* **`n`**: Siguiente coincidencia | **`N`**: Coincidencia anterior.
* **`*`**: Busca la palabra exacta donde está el cursor hacia adelante | **`#`**: Hacia atrás.
* **`<Esc>`**: Limpia el resaltado amarillo de la búsqueda.
* **`<Space> + /`**: Buscador difuso interactivo en el archivo (Telescope).

#### B. Reemplazar una Selección o Palabra
* **Reemplazar selección escribiendo:** Seleccioná texto con `v` $\rightarrow$ presioná **`c`** $\rightarrow$ escribí lo nuevo.
* **Cambiar palabra actual:** Presioná **`ciw`** $\rightarrow$ borra la palabra y te deja escribiendo.
* **Cambiar contenido entre comillas:** Presioná **`ci"`** o **`ci'`**.
* **Cambiar contenido entre paréntesis/llaves:** Presioná **`ci(`** o **`ci{`**.

#### C. Reemplazar Todas las Coincidencias en el Archivo Actual
* **Reemplazar en todo el archivo:** `:%s/antiguo/nuevo/g`
* **Reemplazar pidiendo confirmación paso a paso:** `:%s/antiguo/nuevo/gc`
  *(Confirmaciones: `y` = sí, `n` = no, `a` = todas, `q` = cancelar)*.
* **Reemplazar solo la palabra exacta:** `:%s/\<antiguo\>/nuevo/g`
* **Super-Tip para la palabra del cursor:** Escribí `:%s/` $\rightarrow$ tocá **`Ctrl + r`** y luego **`Ctrl + w`** $\rightarrow$ `/nuevo/g` $\rightarrow$ `<Enter>`.

#### D. Reemplazar en Todo el Proyecto (Multi-archivo)
* **1. Renombrar Variable / Función con LSP:** Parate sobre el identificador y presioná **`<Space> + cr`** (*Code Rename*). Actualiza todos los archivos del repositorio de forma inteligente.
* **2. Buscar y Reemplazar Texto Libre en Todo el Proyecto (TUI interactivo):** Presioná **`<Space> + sr`** (*Search & Replace*). Abre el panel **Grug-Far** con previsualización en vivo.
* **3. Reemplazo masivo por consola:** `sd 'antiguo' 'nuevo' src/**/*.ts`

---

### 3.7 Inteligencia de Código (LSP) y Autocompletado

| Qué querés hacer | Atajo | Explicación |
| :--- | :--- | :--- |
| **Ir a la definición de una función/variable** | **`gd`** | Salta al archivo y línea donde se creó (*Go to Definition*) |
| **Ver referencias / dónde se usa** | **`gr`** | Lista todos los usos del símbolo en el proyecto con Telescope |
| **Ver documentación y tipos flotantes** | **`K`** | Muestra el docstring, tipos y firma de la función (*Hover*) |
| **Renombrar símbolo en todo el proyecto** | **`<Space> + cr`** | Renombra la variable/función de forma segura (*Code Rename*) |
| **Acciones de código / Correcciones rápidas** | **`<Space> + ca`** | Menú para importar módulos faltantes o corregir errores |
| **Formatear el archivo actual** | **`<Space> + cf`** | Aplica Prettier, Stylua, Ruff/Black, etc. |
| **Ver error / advertencia de la línea** | **`<Space> + cd`** | Muestra el diagnóstico en ventana flotante |
| **Saltar al error siguiente / anterior** | **`]d`** / **`[d`** | Navega por los errores de sintaxis del archivo |

#### Atajos del Autocompletado (`blink.cmp`) mientras escribís:
* **`<Tab>`** / **`<S-Tab>`**: Moverse por las sugerencias.
* **`<Enter>`**: Aceptar la sugerencia y autocompletar.
* **`Ctrl + Space`**: Abrir/alternar menú y documentación flotante.
* **`Ctrl + e`**: Cerrar menú de autocompletado.

---

### 3.8 Documentación Automática, Comentarios y Envolturas

* **Generador de Documentación Inteligente (`neogen`):**
  - **`<Space> + cn`**: Genera la plantilla de documentación oficial (**JSDoc / TSDoc**, **Google Docstrings**, **LuaDoc**) para la función/método activo con sus parámetros y tipos.
  - **`<Space> + cnc`**: Documentar clase | **`<Space> + cnt`**: Documentar tipo/interfaz.
  - **Navegación:** Usá **`<Tab>`** para saltar entre los campos generados y escribir descripciones.

* **Comentarios Rápidos Multilenguaje (`ts-comments`):**
  - **`gcc`**: Comentar / Descomentar la línea actual en modo normal.
  - **`gc`**: Comentar / Descomentar el bloque seleccionado en modo visual.

* **Manipulación de Envolturas (`mini.surround`):**
  - **`gsa`** (*Add*): Envolver palabra (`gsa` + `iw` + `"` $\rightarrow$ `"palabra"`).
  - **`gsd`** (*Delete*): Borrar envoltura (`gsd"` sobre `"hola"` $\rightarrow$ `hola`).
  - **`gsr`** (*Replace*): Reemplazar envoltura (`gsr'"` sobre `'texto'` $\rightarrow$ `"texto"`).

---

### 3.9 GitLens y Control de Cambios en Vivo

* **Signos en el Gutter:** Marcas `▎` verde (nuevo), `▎` azul (modificado) y `` rojo (borrado).
* **Inline Blame:** Muestra autor, hora y commit al final de la línea (`󰊢 Autor, 14:30 • feat: add layout`).

| Qué querés hacer | Atajo | Explicación |
| :--- | :--- | :--- |
| **Saltar al siguiente cambio de Git** | **`]c`** | Salta al próximo bloque modificado (*Next Hunk*) |
| **Saltar al cambio anterior de Git** | **`[c`** | Salta al bloque modificado anterior (*Prev Hunk*) |
| **Ver Diff flotante de la línea** | **`<Space> + gp`** | Vista previa emergente de qué cambió |
| **Git Blame detallado en ventana** | **`<Space> + gb`** | Muestra el commit completo y autor |
| **Alternar Git Blame en línea (Toggle)** | **`<Space> + gB`** | Activa / desactiva el texto al final de la línea |
| **Ver Diff lado a lado contra HEAD** | **`<Space> + gd`** | Abre división lateral con diff de Git |
| **Hacer Staging del bloque modificado** | **`<Space> + ghs`** | Agrega solo ese cambio al staging area |
| **Descartar cambios de este bloque** | **`<Space> + ghr`** | Revierte (*Reset*) solo esas líneas |
| **Descartar TODOS los cambios del archivo**| **`<Space> + gR`** | Reestablece el archivo completo |

---

### 3.10 Activación Dinámica de Lenguajes y Plugins (LazyExtras)

| Qué querés hacer | Atajo / Comando | Explicación |
| :--- | :--- | :--- |
| **ACTIVAR / DESACTIVAR LENGUAJES Y EXTRAS**| **`<Space> + px`** (o `:LazyExtras`) | Menú visual con casillas: navegás y tocás **`x`** para prender o apagar TypeScript, Python, Docker, Tailwind, Rust, Go, etc. |
| **Dashboard de Plugins (Lazy UI)** | **`<Space> + pl`** (o `:Lazy`) | Ver plugins cargados (`●`), no cargados (`○`) y tiempos de arranque en ms |
| **Dashboard de Servidores (Mason UI)**| **`<Space> + pm`** (o `:Mason`) | Instalar o actualizar Language Servers, Linters y Formateadores |
| **Restaurar Sesión del Proyecto** | **`<Space> + qs`** | Abre todas las ventanas, pestañas y cursores donde los dejaste |
| **Restaurar Última Sesión de Neovim** | **`<Space> + ql`** | Restaura la última sesión cerrada |
| **Actualizar todos los plugins** | **`<Space> + pu`** | Ejecuta `:Lazy update` |

---
## 🖥️ Terminal, Shell y Prompt

### **Ghostty**
* Emulador de terminal nativo para macOS con aceleración por GPU (Metal).
* Configurado con desenfoque de fondo (*blur radius 20*), opacidad al 0.98, sin marcos de ventana de macOS y con cursor estilo bloque Tokyonight Cyan (`#7dcfff`).

### **Fish Shell**
* Shell interactiva con autocompletado en tiempo real y coloreado sintáctico completo (comandos en azul, comillas en verde, variables en púrpura, errores en rojo).
* Función **`cds`** para purgar recursivamente archivos `.DS_Store` en proyectos macOS.

### **Starship**
* Prompt reactivo en Rust.
* Módulos activos:
  * 📁 Directorio actual (`#7dcfff`) con indicador de solo lectura `󰌾`.
  *  Rama y estado de Git (`#bb9af7` / `#ff9e64`).
  * 󰒋 Runtimes activos vía **mise** (Node ``, Python ``, Java ``).
  * 󱃾 Contexto de Kubernetes (`#7aa2f7`).
  * ⏱️ Duración de comandos cuando superan los 2 segundos (`󱑂`).
  * ❯ Carácter de entrada (`#7aa2f7` en éxito, `#f7768e` en error).

### **atuin**
* Reemplazo del historial tradicional por una base de datos indexada SQLite.
* Presioná **`Ctrl + r`** o **`↑`** para abrir el buscador difuso con duración, hora, directorio y código de salida.
* `atuin stats`: Estadísticas de comandos más frecuentes.

---

## 🪟 Multiplexor de Terminal (Zellij + zjstatus)

Zellij está configurado con un layout de **1 sola línea inferior** (`layouts/default.kdl`) utilizando el plugin local **`zjstatus.wasm`** sin dependencias externas ni diálogos de confirmación de red:

```
┌────────────────────────────────────────────────────────────────────────┐
│ [Panel 1: Proceso / Logs]            │ [Panel 2: Consola]              │
│                                      │                                 │
│                                      │                                 │
├────────────────────────────────────────────────────────────────────────┤
│ NORMAL │ 1: fish  2: lazygit         │ 󰆍 session_name │ 󱑂 14:30        │
└────────────────────────────────────────────────────────────────────────┘
```

* **Modo Normal:** Pestañas con la activa en formato *Badge* de alto contraste (`#3d59a1` + `#7aa2f7`).
* **Al entrar a un modo (`Ctrl+p`, `Ctrl+t`, etc.):** La barra inferior muta al instante mostrando los atajos contextuales con código de colores semántico:
  * `Ctrl + p` (Modo Paneles) -> `n:new`, `d:down`, `r:right`, `x:close`, `f:full`, `w:float`, `z:frames`.
  * `Ctrl + t` (Modo Pestañas) -> `n:new`, `x:close`, `h/l:move`, `r:rename`, `s:sync`.
  * `Ctrl + n` (Modo Redimensionar) -> `+/-:size`, `h/j/k/l:dir`.
  * `Ctrl + s` (Modo Scroll) -> `j/k:scroll`, `d/u:page`, `s:search`, `e:edit`.
  * `Ctrl + o` (Modo Sesión) -> `d:detach`, `w:manager`.

---

## 🔍 Navegación Inteligente y Búsqueda Difusa

### **zoxide (`cd` / `z`)**
* `cd <nombre>`: Salta a cualquier directorio frecuente sin importar cuán profundo esté.
* `zi`: Menú interactivo con FZF para elegir directorios históricos.
* Abreviaturas: `..` (sube 1 nivel), `...` (sube 2 niveles), `-` (vuelve al previo).

### **fzf**
* Motor de búsqueda difusa con colores Tokyonight Night y cursor `▶`.
* `Ctrl + t`: Búsqueda difusa de archivos con `fd` (ignora `.git` y `node_modules`).
* `Alt + c`: Búsqueda difusa y cambio directo a carpetas.

### **yazi (`y` / `yz`)**
* Administrador de archivos TUI asíncrono con vista previa de texto e imágenes.
* Usá el alias `y` para que al salir con `q` tu terminal quede ubicada en la carpeta explorada.

### **eza & bat**
* `ls`, `ll`, `la`, `tree`: Listados visuales con íconos y carpetas agrupadas primero.
* `cat`: Visor con sintaxis coloreada Tokyonight y marcas de Git.

---

## 🌐 APIs, Datos y JSON

### **xh**
* Cliente HTTP ergonómico y veloz (reemplazo de `curl`).
* `xh GET api.github.com/users/octocat`
* `xh POST httpbin.org/post name="Gentleman" role="Architect"`

### **jq & jqp**
* `jq`: Procesamiento y formateo de streams JSON por consola.
* `jqp`: Playground TUI interactivo para probar filtros de `jq` en tiempo real.
  ```bash
  cat respuesta.json | jqp
  ```

---

## 📊 Monitoreo, Procesos y Contenedores

### **bottom (`btm`)**
* Monitor gráfico en tiempo real de CPU por núcleo, Memoria/Swap, Red, Discos y Procesos.
* `t` (ordenar por CPU), `m` (ordenar por Memoria), `dd` (terminar proceso), `/` (filtrar).

### **procs**
* Reemplazo enriquecido de `ps`.
* `procs --port 3000`: Muestra qué proceso exacto está utilizando el puerto 3000.
* `procs --tree`: Vista en árbol de procesos.

### **dust (`du`)**
* Visualizador interactivo del espacio en disco en barras gráficas.
* `dust -d 2`: Análisis a 2 niveles de profundidad.

### **lazydocker & k9s**
* `lazydocker`: TUI para contenedores, imágenes, volúmenes y logs en vivo de Docker.
* `k9s`: Panel TUI para clusters de Kubernetes.
* `kubectx` / `kubens`: Alternar contextos y namespaces de Kubernetes interactivamente.

---

## ⚡ Tabla Maestra de Alias y Atajos

| Alias / Atajo | Comando Real | Descripción |
| :--- | :--- | :--- |
| **`g`** | `git` | Binario de Git |
| **`gs`** | `git status` | Estado de archivos y cambios |
| **`gc`** | `git commit` | Crear un commit |
| **`gch`** | `git checkout` | Cambiar de rama / restaurar |
| **`gd`** | `git diff` | Ver diffs con sintaxis Delta |
| **`gl`** | `git log --graph (Tokyonight)` | Árbol visual de commits con autor y tiempo |
| **`glog`** | `git log --graph --all` | Árbol completo de todas las ramas |
| **`glp`** | `git log -p` | Historial detallado con diffs en Delta |
| **`gp`** | `git push` | Subir commits a rama remota |
| **`gaa`** | `git add .` | Staging de todos los cambios |
| **`lg`** | `lazygit` | Interfaz TUI completa para Git |
| **`of`** | `onefetch` | Radiografía visual de repositorio Git |
| **`v`** | `nvim` | Editor principal Neovim Tokyonight |
| **`zj`** | `zellij` | Multiplexor con barra 1-línea Tokyonight |
| **`y`** | `yazi (wrapper cwd)` | File manager con salto automático al salir |
| **`yz`** | `yazi` | File manager directo |
| **`jqp`** | `jqp` | Playground interactivo de filtros JQ |
| **`cat`** | `bat --style=plain` | Visor con sintaxis Tokyonight |
| **`ls`** | `eza --icons` | Lista limpia con íconos |
| **`ll`** | `eza -la --icons` | Lista detallada completa |
| **`tree`** | `eza --tree --icons` | Estructura en árbol visual |
| **`btm`** | `bottom` | Monitor interactivo de sistema |
| **`du`** | `dust` | Uso gráfico de espacio en disco |
| **`md`** | `glow` | Lector enriquecido de Markdown |
| **`cds`** | `find . -name ".DS_Store" -delete` | Limpieza de archivos basura en macOS |
| **`cd`** | `zoxide (z)` | Salto inteligente a carpetas |
| **`..` / `...`** | `z ..` / `z ../..` | Subir 1 o 2 niveles de carpetas |
| **`-`** | `z -` | Regresar al directorio previo |
| **`Ctrl + r`** | `atuin search / fzf` | Historial inteligente con tiempos y estado |
| **`Ctrl + t`** | `fzf (fd files)` | Búsqueda difusa de archivos |
| **`Alt + c`** | `fzf (fd dirs)` | Búsqueda difusa de carpetas |
