# ⚡ Tabla Maestra de Alias y Atajos

Referencia rápida de todos los alias y atajos disponibles en **OhMyConfig**.

---

## 1. Terminal y Shell (Fish / Zoxide / Git)

| Alias / Atajo | Comando Real | Descripción |
| :--- | :--- | :--- |
| **`v`** | `nvim` | Editor principal Neovim Tokyonight |
| **`zj`** | `zellij` | Multiplexor de terminal con barra Tokyonight |
| **`g`** | `git` | Binario de Git |
| **`gs`** | `git status` | Estado de archivos y cambios |
| **`gc`** | `git commit` | Crear un commit estructurado |
| **`gch`** | `git checkout` | Cambiar de rama / restaurar |
| **`gd`** | `git diff` | Ver diffs con sintaxis Delta |
| **`gl`** | `git log --graph` | Árbol visual de commits con autor y tiempo |
| **`glog`** | `git log --graph --all` | Árbol completo de todas las ramas |
| **`glp`** | `git log -p` | Historial detallado con diffs en Delta |
| **`gp`** | `git push` | Subir commits a rama remota |
| **`gaa`** | `git add .` | Staging de todos los cambios |
| **`lg`** | `lazygit` | Interfaz TUI completa para Git |
| **`of`** | `onefetch` | Radiografía visual de repositorio Git |
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
| **`Ctrl + r`** | `atuin search` | Historial SQLite con tiempos y estado |
| **`Ctrl + t`** | `fzf (fd files)` | Búsqueda difusa de archivos |
| **`Alt + c`** | `fzf (fd dirs)` | Búsqueda difusa de carpetas |

---

## 2. Multiplexor Zellij (`zj`)

| Atajo | Modo | Acción |
| :--- | :--- | :--- |
| **`Alt + Flechas`** (o `Alt + hjkl`) | Normal | Mover foco entre paneles (resalta en Cyan) |
| **`Alt + [`** / **`Alt + ]`** | Normal | Pestaña anterior / siguiente |
| **`Alt + 1` .. `Alt + 9`** | Normal | Saltar directo a la pestaña N |
| **`Alt + t`** | Normal | Crear nueva pestaña |
| **`Alt + n`** | Normal | Crear nuevo panel |
| **`Alt + f`** | Normal | Alternar pantalla completa en panel activo |
| **`Alt + w`** | Normal | Alternar paneles flotantes |
| **`Ctrl + p`** | Normal $\rightarrow$ Pane | Entrar al modo de gestión de paneles |
| **`Ctrl + t`** | Normal $\rightarrow$ Tab | Entrar al modo de gestión de pestañas |
| **`Ctrl + s`** | Normal $\rightarrow$ Scroll | Entrar al modo scroll y búsqueda en historial |
| **`Ctrl + n`** | Normal $\rightarrow$ Resize | Entrar al modo redimensionar paneles |
| **`Ctrl + o`** | Normal $\rightarrow$ Session | Entrar al modo desconectar/administrar sesión |

---

## 3. Editor Neovim (`v`)

| Atajo | Modo | Acción |
| :--- | :--- | :--- |
| **`<Space> + e`** | Normal | Abrir / Ocultar explorador de archivos lateral |
| **`Ctrl + h/j/k/l`** | Normal | Moverse entre paneles y divisiones |
| **`Shift + l` / `Shift + h`** | Normal | Siguiente / Anterior pestaña (buffer) |
| **`<Space> + bd`** | Normal | Cerrar pestaña/buffer limpiamente sin `[No Name]` |
| **`<Space> + w`** | Normal | Guardar archivo actual |
| **`u`** / **`Ctrl + r`** | Normal | Deshacer persistente / Rehacer |
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
