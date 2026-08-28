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
3. [🖥️ Terminal, Shell y Prompt](#️-terminal-shell-y-prompt)
4. [🪟 Multiplexor de Terminal (Zellij + zjstatus)](#-multiplexor-de-terminal-zellij--zjstatus)
5. [🔍 Navegación Inteligente y Búsqueda Difusa](#-navegación-inteligente-y-búsqueda-difusa)
6. [🌐 APIs, Datos y JSON](#-apis-datos-y-json)
7. [📊 Monitoreo, Procesos y Contenedores](#-monitoreo-procesos-y-contenedores)
8. [⚡ Tabla Maestra de Alias y Atajos](#-tabla-maestra-de-alias-y-atajos)

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
