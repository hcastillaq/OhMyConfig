---
title: "Tabla Maestra de Alias y Atajos"
description: "Referencia rápida de todos los alias, atajos y comandos de OhMyConfig."
---

# ⚡ Tabla Maestra de Alias y Atajos

Referencia rápida de todos los alias, herramientas y atajos disponibles en **OhMyConfig**.

---

## 1. Terminal, Búsqueda y Navegación (Fish / Zoxide / FZF / Ripgrep)

| Alias / Atajo | Comando Real | Descripción |
| :--- | :--- | :--- |
| **`cheat`** / **`ayuda`** | `omc` | Alias para abrir la ayuda de la CLI |
| **`v`** / **`vi`** / **`vim`** | `nvim` | Editor principal Neovim Static Noise |
| **`zj`** | `zellij` | Multiplexor de terminal con barra Static Noise |
| **`rg <patron>`** | `ripgrep` | Búsqueda de texto en archivos en milisegundos |
| **`fd <nombre>`** | `fd` | Búsqueda moderna de archivos y carpetas |
| **`sd 'old' 'new'`**| `sd` | Reemplazo intuitivo de texto en archivos |
| **`cd <carpeta>`** | `zoxide (z)` | Salto inteligente a carpetas frecuentes |
| **`zi`** | `zoxide (zi)` | Selector interactivo de carpetas con FZF |
| **`..` / `...` / `....`** | `z ..` / `z ../..` / `z ../../..` | Subir 1, 2 o 3 niveles de carpetas |
| **`-`** | `z -` | Regresar al directorio previo |
| **`Ctrl + r`** | `atuin search` | Historial SQLite con buscador difuso y tiempos |
| **`Ctrl + t`** | `fzf (fd files)` | Búsqueda difusa de archivos en la terminal |
| **`Alt + c`** | `fzf (fd dirs)` | Búsqueda difusa y salto directo a carpetas |
| **`y`** | `yazi (wrapper cwd)` | File manager con salto automático al salir con `q` |
| **`yz`** | `yazi` | File manager directo |
| **`ls`** | `eza --icons` | Lista limpia con íconos |
| **`ll`** | `eza -la --icons` | Lista detallada completa |
| **`la`** | `eza -a --icons` | Lista archivos ocultos |
| **`tree`** | `eza --tree --icons` | Estructura en árbol visual |
| **`cat`** | `bat --style=plain` | Visor con sintaxis coloreada Static Noise |
| **`btm`** | `bottom` | Monitor interactivo de sistema (CPU/RAM/Discos) |
| **`du`** | `dust` | Uso visual de espacio en disco en barras |
| **`procs`** | `procs` | Visor de procesos moderno con `--port` y `--tree` |
| **`tokei`** | `tokei` | Estadísticas y conteo de líneas de código |
| **`xh`** | `xh` | Cliente HTTP veloz para probar endpoints |
| **`jqp`** / **`jqplay`** | `jqp` | Playground interactivo para filtros de JQ |
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

> Zellij usa un mapa **Alt-first** con `clear-defaults=true`: las combinaciones `Ctrl` quedan libres para Neovim, Fish, readline y otras TUIs.

| Atajo | Modo | Acción |
| :--- | :--- | :--- |
| **`Alt + h/j/k/l`** | Normal | Mover foco entre paneles (izquierda, abajo, arriba, derecha) |
| **`Alt + Shift + h/j/k/l`** | Normal | Mover físicamente el panel activo en esa dirección |
| **`Alt + n`** | Normal | Crear nuevo panel directamente |
| **`Alt + x`** | Normal | Cerrar panel activo |
| **`Alt + f`** | Normal | Alternar pantalla completa en panel activo |
| **`Alt + w`** | Normal | Alternar paneles flotantes (Floating Panes) |
| **`Alt + [`** / **`Alt + ]`** | Normal | Pestaña anterior / siguiente |
| **`Alt + t`** | Normal | Crear nueva pestaña |
| **`Alt + q`** | Normal | Cerrar pestaña actual |
| **`Alt + r`** | Normal $\rightarrow$ RenameTab | Renombrar pestaña actual |
| **`Alt + 1` .. `Alt + 9`** | Normal | Saltar directo a la pestaña número N |
| **`Alt + p`** | Normal $\leftrightarrow$ Pane | Entrar/salir del modo de gestión de paneles |
| **`Alt + Shift + t`** | Normal $\leftrightarrow$ Tab | Entrar/salir del modo de gestión de pestañas |
| **`Alt + m`** | Normal $\leftrightarrow$ Move | Entrar/salir del modo mover paneles |
| **`Alt + z`** | Normal $\leftrightarrow$ Resize | Entrar/salir del modo redimensionar paneles |
| **`Alt + s`** | Normal $\leftrightarrow$ Scroll | Entrar/salir del modo scroll y búsqueda en historial |
| **`Alt + o`** | Normal $\leftrightarrow$ Session | Entrar/salir del modo sesión |
| **`Alt + d`** | Normal | Desconectar (*detach*) la sesión |

---

## 4. Editor Neovim (`v`)

| Atajo | Modo | Acción |
| :--- | :--- | :--- |
| **`<Space> + e`** | Normal | Abrir / Ocultar explorador de archivos lateral |
| **`Ctrl + h/j/k/l`** | Normal | Moverse entre paneles y divisiones |
| **`<Space> + wh/j/k/l`** | Normal | Mover foco entre ventanas (izq, abajo, arriba, der) |
| **`Shift + l`** / **`Shift + h`** | Normal | Pestaña siguiente / anterior (`]b` / `[b`) |
| **`<Space> + bd`** | Normal | Cerrar pestaña/buffer limpiamente sin `[No Name]` |
| **`<Space> + bo`** | Normal | Cerrar todas las demás pestañas excepto la activa |
| **`<Space> + bb`** | Normal | Alternar con la pestaña previa |
| **`<Space> + bj`** (o `<Space> + sb`) | Normal | Selector difuso de pestañas abiertas |
| **`Ctrl + s`** / **`<Space> + fs`** | Normal / Insert | Guardar archivo actual en disco (universal) |
| **`p`** (en selección visual) | Visual | Pegar del sistema sin sobreescribir lo copiado |
| **`<Space> + w`** | Normal | Menú de ventanas y divisiones (`v` vertical, `s` horizontal, `d` cerrar) |
| **`<Space> + wm`** / **`<Space> + w=`** | Normal | Maximizar ventana (Zoom) / Balancear tamaños |
| **`u`** / **`Ctrl + r`** | Normal | Deshacer persistente en disco / Rehacer |
| **`s`** + 2 letras | Normal | Salto instantáneo en pantalla (Flash) |
| **`Ctrl + Space`** | Normal / Insert | Modo Normal: selección incremental | Inserción: autocompletado |
| **`gcc`** / **`gc`** | Normal / Visual | Comentar línea o bloque seleccionado de código |
| **`<Space> + cb`** | Normal | Añadir comentario en línea siguiente |
| **`<Space> + sf`** (o `<Space> + <Space>`) | Normal | Buscar archivos por nombre en el proyecto |
| **`<Space> + sg`** | Normal | Buscar texto en archivos del proyecto (Live Grep) |
| **`<Space> + sw`** | Normal | Buscar palabra bajo cursor en todo el proyecto |
| **`<Space> + ss`** / **`<Space> + sS`** | Normal | Buscar símbolos en archivo / en todo el proyecto |
| **`<Space> + sb`** | Normal | Buscar pestañas y buffers abiertos |
| **`<Space> + s/`** | Normal | Buscar difuso dentro del archivo actual |
| **`<Space> + st`** | Normal | Buscar comentarios TODO / FIXME en proyecto |
| **`<Space> + rp`** | Normal / Visual | Reemplazar en proyecto completo (Grug-Far TUI) |
| **`<Space> + rw`** | Normal / Visual | Reemplazar palabra actual o selección en proyecto |
| **`<Space> + rb`** | Normal / Visual | Reemplazar en archivo actual con confirmación (`:%s///gc`) |
| **`<Space> + ca`** | Normal | Menú de correcciones rápidas sugeridas (*Code Action*) |
| **`<Space> + cr`** | Normal | Renombrar símbolo en todo el proyecto (LSP Rename) |
| **`<Space> + cf`** | Normal | Formatear archivo actual |
| **`<Space> + cd`** | Normal | Ver explicación y diagnóstico del error de la línea |
| **`<Space> + cx`** (o `<Space> + xx`) | Normal | Panel inferior de errores y diagnósticos (Trouble) |
| **`<Space> + cn`** | Normal | Generar docstrings estructurados (Neogen) |
| **`<Space> + cA`** | Normal | Organizar imports / correcciones globales de archivo |
| **`[d`** / **`]d`** | Normal | Saltar al anterior / siguiente error de sintaxis |
| **`<Space> + cD`** / **`gd`** | Normal | Ir a definición de función/variable/clase |
| **`<Space> + cI`** / **`gI`** | Normal | Ir a implementación de interfaz (Java/TS/Go) |
| **`<Space> + cy`** / **`gy`** | Normal | Ir a definición de tipo de dato (Type Definition) |
| **`Ctrl + o`** / **`Ctrl + i`** | Normal | Volver al origen tras salto (*Jump Back*) / Avanzar |
| **`<Space> + ch`** / **`K`** | Normal | Ver documentación y firma de tipos flotante (Hover) |
| **`gr`** | Normal | Ver todas las referencias y usos del símbolo |
| **`<Space> + px`** | Normal | Abrir menú `:LazyExtras` para activar/desactivar lenguajes |
| **`<Space> + pl`** | Normal | Abrir panel `:Lazy` de plugins |
| **`<Space> + pm`** | Normal | Abrir panel `:Mason` de servidores y herramientas |
| **`<Space> + gg`** | Normal | Abrir interfaz visual de Lazygit en ventana flotante |
| **`<Space> + ghp`** | Normal | Vista previa flotante del Diff de Git |
| **`<Space> + gb`** / **`gB`** | Normal | Git Blame en ventana / alternar en línea |
| **`<Space> + gd`** | Normal | Ver Diff lado a lado contra HEAD |
| **`]c`** / **`[c`** | Normal | Siguiente / Anterior cambio de Git (Hunk) |

---

## 5. Ecosistema AI & Pi

| Comando / Atajo | Contexto | Descripción |
| :--- | :--- | :--- |
| **`./omc dev`** | Terminal | Instalar sólo el CLI base de Pi |
| **`./omc dev install`** | Terminal | Instalar sólo el CLI base de Pi |
| **`./omc dev status`** | Terminal | Ver versión de `pi` y paquetes actuales con `pi list` |
| **`./omc dev update`** | Terminal | Actualizar sólo el binario base de `pi` |
| **`./omc dev doctor`** | Terminal | Diagnóstico local de Node/npm/Pi |
| **`./omc dev remove`** | Terminal | Ayuda para remover extensiones con `pi remove` |
| **`pi`** | Terminal | Iniciar sesión interactiva del agente de codificación |
| **`pi list`** | Terminal | Listar paquetes/extensiones instaladas |
| **`pi install <paquete>`** | Terminal | Instalar herramientas opcionales bajo demanda |
| **`pi remove <paquete>`** | Terminal | Desinstalar una extensión opcional |
| **`/council <pregunta>`** | Pi Session | Consejo consultivo si está instalado `pi-model-council` |
| **`$skill-name`** | Pi Session | Mención difusa si está instalado `pi-skill-dollar` |
| **`./omc update`** | Terminal | Actualización completa del entorno; AI actualiza sólo Pi base |
