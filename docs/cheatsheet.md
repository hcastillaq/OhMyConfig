# ⚡ Tabla Maestra de Alias y Atajos

Referencia rápida de todos los alias, herramientas y atajos disponibles en **OhMyConfig**.

---

## 1. Terminal, Búsqueda y Navegación (Fish / Zoxide / FZF / Ripgrep)

| Alias / Atajo | Comando Real | Descripción |
| :--- | :--- | :--- |
| **`v`** | `nvim` | Editor principal Neovim Tokyonight |
| **`zj`** | `zellij` | Multiplexor de terminal con barra Tokyonight |
| **`guia`** (o `omc`) | `omc` | Menú interactivo de atajos en consola |
| **`rg <patron>`** | `ripgrep` | Búsqueda de texto en archivos en milisegundos |
| **`fd <nombre>`** | `fd` | Búsqueda moderna de archivos y carpetas |
| **`sd 'old' 'new'`**| `sd` | Reemplazo intuitivo de texto en archivos |
| **`cd <carpeta>`** | `zoxide (z)` | Salto inteligente a carpetas frecuentes |
| **`zi`** | `zoxide (zi)` | Selector interactivo de carpetas con FZF |
| **`..` / `...`** | `z ..` / `z ../..` | Subir 1 o 2 niveles de carpetas |
| **`-`** | `z -` | Regresar al directorio previo |
| **`Ctrl + r`** | `atuin search` | Historial SQLite con buscador difuso y tiempos |
| **`Ctrl + t`** | `fzf (fd files)` | Búsqueda difusa de archivos en la terminal |
| **`Alt + c`** | `fzf (fd dirs)` | Búsqueda difusa y salto directo a carpetas |
| **`y`** | `yazi (wrapper cwd)` | File manager con salto automático al salir con `q` |
| **`yz`** | `yazi` | File manager directo |
| **`ls`** | `eza --icons` | Lista limpia con íconos |
| **`ll`** | `eza -la --icons` | Lista detallada completa |
| **`tree`** | `eza --tree --icons` | Estructura en árbol visual |
| **`cat`** | `bat --style=plain` | Visor con sintaxis coloreada Tokyonight |
| **`btm`** | `bottom` | Monitor interactivo de sistema (CPU/RAM/Discos) |
| **`du`** | `dust` | Uso visual de espacio en disco en barras |
| **`procs`** | `procs` | Visor de procesos moderno con `--port` y `--tree` |
| **`tokei`** | `tokei` | Estadísticas y conteo de líneas de código |
| **`xh`** | `xh` | Cliente HTTP veloz para probar endpoints |
| **`jqp`** | `jqp` | Playground interactivo para filtros de JQ |
| **`lazydocker`** | `lazydocker` | Panel visual interactivo para Docker |
| **`k9s`** | `k9s` | Panel visual interactivo para Kubernetes |
| **`kubectx / kubens`**| `kubectx / kubens` | Cambiar de contexto / namespace en K8s |
| **`md <file>`** | `glow` | Lector enriquecido de Markdown en terminal |
| **`cds`** | `find . -name ".DS_Store" -delete` | Limpieza de archivos basura en macOS |

---

## 2. Git y Control de Versiones

| Alias / Atajo | Comando Real | Descripción |
| :--- | :--- | :--- |
| **`g`** | `git` | Binario de Git |
| **`gs`** | `git status` | Estado de archivos y cambios |
| **`gaa`** | `git add .` | Staging de todos los cambios |
| **`gc`** | `git commit` | Crear un commit estructurado |
| **`gch`** | `git checkout` | Cambiar de rama / restaurar |
| **`gd`** | `git diff` | Ver diffs con sintaxis Delta |
| **`gl`** | `git log --graph` | Árbol visual de commits con autor y tiempo |
| **`glog`** | `git log --graph --all` | Árbol completo de todas las ramas |
| **`glp`** | `git log -p` | Historial detallado con diffs interactivos en Delta |
| **`gp`** | `git push` | Subir commits a rama remota |
| **`lg`** | `lazygit` | Interfaz TUI completa para Git |
| **`of`** | `onefetch` | Radiografía visual con telemetría del repositorio |

---

## 3. Multiplexor Zellij (`zj`)

| Atajo | Modo | Acción |
| :--- | :--- | :--- |
| **`Alt + Flechas`** (o `Alt + hjkl`) | Normal | Mover foco entre paneles (se ilumina en Cyan) |
| **`Alt + [`** / **`Alt + ]`** | Normal | Pestaña anterior / siguiente |
| **`Alt + 1` .. `Alt + 9`** | Normal | Saltar directo a la pestaña número N |
| **`Alt + n`** | Normal | Crear nuevo panel directamente |
| **`Alt + f`** | Normal | Alternar pantalla completa en panel activo |
| **`Alt + w`** | Normal | Alternar paneles flotantes (Floating Panes) |
| **`Ctrl + p`** | Normal $\rightarrow$ Pane | Entrar al modo de gestión de paneles |
| **`Ctrl + t`** | Normal $\rightarrow$ Tab | Entrar al modo de gestión de pestañas |
| **`Ctrl + s`** | Normal $\rightarrow$ Scroll | Entrar al modo scroll y búsqueda en historial |
| **`Ctrl + n`** | Normal $\rightarrow$ Resize | Entrar al modo redimensionar paneles |
| **`Ctrl + o`** | Normal $\rightarrow$ Session | Entrar al modo desconectar/administrar sesión |

---

## 4. Editor Neovim (`v`)

| Atajo | Modo | Acción |
| :--- | :--- | :--- |
| **`<Space> + e`** | Normal | Abrir / Ocultar explorador de archivos lateral |
| **`Ctrl + h/j/k/l`** | Normal | Moverse entre paneles y divisiones |
| **`Shift + l` / `Shift + h`** | Normal | Siguiente / Anterior pestaña (buffer) |
| **`<Space> + bd`** | Normal | Cerrar pestaña/buffer limpiamente sin `[No Name]` |
| **`<Space> + w`** | Normal | Guardar archivo actual (`:w`) |
| **`u`** / **`Ctrl + r`** | Normal | Deshacer persistente en disco / Rehacer |
| **`s`** + 2 letras | Normal | Salto instantáneo en pantalla (Flash) |
| **`Ctrl + Space`** | Normal | Selección incremental de código (Treesitter) |
| **`gd`** / **`K`** | Normal | Ir a definición / Ver documentación flotante (LSP) |
| **`<Space> + cr`** | Normal | Renombrar variable en todo el proyecto (LSP) |
| **`<Space> + sr`** | Normal | Buscar y reemplazar texto en todo el proyecto (Grug-Far) |
| **`<Space> + ca`** | Normal | Acciones rápidas y correcciones (LSP) |
| **`<Space> + cf`** | Normal | Formatear archivo |
| **`<Space> + cn`** | Normal | Generar documentación inteligente (Neogen) |
| **`<Space> + px`** | Normal | Abrir menú `:LazyExtras` para activar lenguajes |
| **`<Space> + pl`** | Normal | Abrir panel `:Lazy` de plugins |
| **`<Space> + pm`** | Normal | Abrir panel `:Mason` de servidores |
| **`gcc`** / **`gc`** | Normal / Visual | Comentar línea o bloque de código |
| **`]c`** / **`[c`** | Normal | Siguiente / Anterior cambio de Git (GitLens) |
| **`<Space> + gp`** | Normal | Vista previa flotante del Diff de Git |
| **`<Space> + gb`** / **`gB`** | Normal | Git Blame en ventana / alternar en línea |

---

## 5. Ecosistema AI & Agentes de Código

| Comando | Contexto | Descripción |
| :--- | :--- | :--- |
| **`./omc dev`** | Terminal | Instalar el stack de IA (`pi`, `gentle-pi`, `gentle-engram`) |
| **`./omc dev status`**| Terminal | Ver versiones instaladas vs última disponible en npm |
| **`./omc dev update`**| Terminal | Actualizar todo el ecosistema de IA a la última versión |
| **`pi`** | Terminal | Iniciar sesión interactiva del agente de codificación |
| **`pi install gentle-pi`** | Pi CLI | Activar el harness de desarrollo controlado y skills |
| **`pi install gentle-engram`** | Pi CLI | Activar la memoria episódica persistente entre sesiones |
| **`./omc update`** | Terminal | Actualización completa (Homebrew + Casks + AI/Pi) |
