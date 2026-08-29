# 🛠️ Guía Maestra de Neovim (Editor Principal)

OhMyConfig utiliza el núcleo de **LazyVim** como motor base de alto rendimiento, delegando el mantenimiento upstream de plugins a la comunidad mientras preserva una capa de usuario limpia y personalizada bajo la estética **Tokyonight Night** con transparencia adaptativa para Ghostty.

```text
config/nvim/
├── init.lua                      # Entrada principal (Bootstrap de LazyVim)
├── lazyvim.json                  # Registro de módulos y lenguajes activos (LazyExtras)
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

## 1. Conceptos Fundamentales: Modos y Tecla Leader

Neovim es un **editor modal**: cambiás de modo según lo que quieras hacer.

```
┌────────────────────────────────────────────────────────────────────────┐
│                          LOS 4 MODOS CLAVE                             │
├──────────────────┬──────────────────┬─────────────────┬────────────────┤
│  NORMAL (<Esc>)  │   INSERT (`i`)   │  VISUAL (`v`)   │  COMANDO (`:`) │
│ Navegación, corte│ Escritura de     │ Selección de    │ Guardar (:w),  │
│ y comandos rápidos│ texto estándar   │ texto y bloques │ salir (:q), etc│
└──────────────────┴──────────────────┴─────────────────┴────────────────┘
```

* **Abrir Neovim:** `v` o `v <archivo>` desde cualquier terminal.
* **Tecla `<leader>`:** La **barra espaciadora** (`<Space>`).
* **Which-Key:** Al tocar `<Space>` en modo normal, tras 200 ms se abre una ventana emergente recordándote todas las opciones.
* **Regla de Oro:** Al terminar de escribir, tocá **`<Esc>`** para volver al **Modo Normal**.

---

## 2. Moverse por el Código a Máxima Velocidad

| Qué querés hacer | Atajo en Modo Normal | Explicación |
| :--- | :--- | :--- |
| **Moverse 1 posición** | **`h`** / **`j`** / **`k`** / **`l`** | Izquierda (`h`), Abajo (`j`), Arriba (`k`), Derecha (`l`) |
| **Saltar de palabra en palabra** | **`w`** / **`b`** | Siguiente palabra (`w`), Palabra anterior (`b`) |
| **Ir al inicio / fin de la línea** | **`0`** / **`$`** | `0` primer carácter, `$` final de línea |
| **Ir al inicio / fin del archivo** | **`gg`** / **`G`** | `gg` primera línea, `G` última línea |
| **Saltar N líneas con números relativos** | **`5j`**, **`12k`**, etc. | Mirás el número en el margen izquierdo y saltás exacto |
| **SALTO INSTANTÁNEO EN PANTALLA (Flash)** | **`s`** + 2 letras + tecla guía | Saltás a cualquier palabra visible en el monitor en 1 ms |
| **Selección incremental de código** | **`Ctrl + Space`** | Expande: variable $\rightarrow$ línea $\rightarrow$ función $\rightarrow$ clase |

---

## 3. Ventanas, Splits y Explorador de Archivos

| Qué querés hacer | Atajo | Explicación |
| :--- | :--- | :--- |
| **Abrir / Ocultar Explorador de Archivos** | **`<Space> + e`** | Abre el panel lateral resaltando el archivo actual |
| **Ver Estado de Git en el Explorador** | **`<Space> + ge`** | Abre el árbol mostrando solo archivos modificados |
| **Moverse al panel izquierdo (Explorador)** | **`Ctrl + h`** | Cambia el foco del código al explorador lateral |
| **Moverse al panel derecho (Editor)** | **`Ctrl + l`** | Vuelve del explorador al código |
| **Moverse a panel inferior / superior** | **`Ctrl + j`** / **`Ctrl + k`** | Navega entre ventanas divididas horizontalmente |
| **Redimensionar paneles** | **`Ctrl + Flechas`** | Ajusta el ancho o alto de la ventana activa |

### Atajos rápidos DENTRO del Explorador:
* **`l`** o **`<Enter>`**: Abre el archivo (o entra a una carpeta).
* **`h`**: Cierra/contrae la carpeta.
* **`a`**: Crear archivo o carpeta (terminar con `/` para carpeta).
* **`d`**: Borrar | **`r`**: Renombrar | **`c`** / **`m`**: Copiar / Mover.
* **`P`**: Vista previa flotante | **`H`**: Mostrar ocultos (`.dotfiles`) | **`?`**: Ayuda completa.

### Íconos de Estado de Git en el Árbol:
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

## 4. Pestañas Superiores (Buffers), Guardado y Deshacer

| Qué querés hacer | Atajo / Comando | Explicación |
| :--- | :--- | :--- |
| **Guardar archivo actual** | **`<Space> + w`** (o `:w`) | Guarda los cambios en disco |
| **Cerrar pestaña actual limpiamente** | **`<Space> + bd`** | Cierra el archivo sin dejar pestañas `[No Name]` |
| **Cerrar todas las demás pestañas** | **`<Space> + bo`** | Cierra todos los buffers excepto el actual |
| **Siguiente / Anterior pestaña** | **`Shift + l`** / **`Shift + h`** | Navega por la barra superior de pestañas |
| **Elegir pestaña interactivamente** | **`<Space> + bp`** | Teclas guía para saltar a cualquier pestaña |
| **Cerrar ventana / split** | **`<Space> + q`** (o `:q`) | Cierra la ventana activa |
| **DESHACER (Undo Persistente)** | **`u`** | Deshace cambios (incluso tras apagar la PC) |
| **REHACER (Redo)** | **`Ctrl + r`** | Rehace el cambio deshecho |
| **Descartar cambios y recargar** | **`:e!`** | Vuelve a leer el archivo desde el disco |
| **Salir de Neovim descartando todo** | **`:qa!`** | Cierra todas las ventanas sin guardar |

---

## 5. Copiar, Cortar, Pegar y Portapapeles de macOS

> 🌐 **Sincronización Total:** Lo que copies con `y` queda en el portapapeles de macOS (`Cmd + V` en Chrome/Slack), y lo que copies afuera con `Cmd + C` se pega en Neovim con `p`.

| Acción | Modo Normal | Modo Visual (`v`) |
| :--- | :--- | :--- |
| **Copiar toda la línea** | **`yy`** | — |
| **Copiar palabra actual** | **`yiw`** (*Yank Inside Word*) | — |
| **Copiar bloque o párrafo** | **`yap`** (*Yank Around Paragraph*) | — |
| **Copiar texto seleccionado** | — | Seleccioná y tocá **`y`** |
| **Cortar / Borrar toda la línea** | **`dd`** | — |
| **Cortar / Borrar palabra actual** | **`diw`** | — |
| **Cortar texto seleccionado** | — | Seleccioná y tocá **`d`** |
| **Pegar después / antes del cursor** | **`p`** / **`P`** | — |
| **Reemplazar selección pegando** | — | Seleccioná texto y tocá **`p`** (pegado seguro) |

---

## 6. Búsqueda y Reemplazo

### A. Buscar dentro del archivo actual
* **`/palabra` + `<Enter>`**: Buscar hacia adelante | **`?palabra` + `<Enter>`**: Buscar hacia atrás.
* **`n`**: Siguiente coincidencia | **`N`**: Coincidencia anterior.
* **`*`**: Busca la palabra del cursor hacia adelante | **`#`**: Hacia atrás.
* **`<Esc>`**: Limpia el resaltado amarillo de búsqueda.
* **`<Space> + /`**: Buscador difuso interactivo en el archivo (Telescope).

### B. Reemplazar una Selección o Palabra
* **Reemplazar selección escribiendo:** Seleccioná con `v` $\rightarrow$ presioná **`c`** $\rightarrow$ escribí lo nuevo.
* **Cambiar palabra actual:** **`ciw`** $\rightarrow$ borra la palabra y te deja escribiendo.
* **Cambiar contenido entre comillas:** **`ci"`** o **`ci'`**.
* **Cambiar contenido entre paréntesis/llaves:** **`ci(`** o **`ci{`**.

### C. Reemplazar Todas las Coincidencias en el Archivo Actual
* **Reemplazar en todo el archivo:** `:%s/antiguo/nuevo/g`
* **Reemplazar pidiendo confirmación:** `:%s/antiguo/nuevo/gc` *(y = sí, n = no, a = todas, q = cancelar)*.
* **Reemplazar solo la palabra exacta:** `:%s/\<antiguo\>/nuevo/g`
* **Super-Tip para la palabra del cursor:** Escribí `:%s/` $\rightarrow$ tocá **`Ctrl + r`** y luego **`Ctrl + w`** $\rightarrow$ `/nuevo/g` $\rightarrow$ `<Enter>`.

### D. Reemplazar en Todo el Proyecto (Multi-archivo)
* **1. Renombrar Variable / Función con LSP:** Parate sobre el identificador y presioná **`<Space> + cr`** (*Code Rename*).
* **2. Buscar y Reemplazar Texto Libre en Todo el Proyecto (TUI):** Presioná **`<Space> + sr`** (*Search & Replace con Grug-Far*).
* **3. Reemplazo masivo por consola:** `sd 'antiguo' 'nuevo' src/**/*.ts`.

---

## 7. Inteligencia de Código (LSP) y Autocompletado

| Qué querés hacer | Atajo | Explicación |
| :--- | :--- | :--- |
| **Ir a la definición de una función/variable** | **`gd`** | Salta a donde se creó (*Go to Definition*) |
| **Ver referencias / dónde se usa** | **`gr`** | Lista todos los usos del símbolo con Telescope |
| **Ver documentación y tipos flotantes** | **`K`** | Muestra el docstring y tipos de la función (*Hover*) |
| **Renombrar símbolo en todo el proyecto** | **`<Space> + cr`** | Renombra la variable/función de forma segura (*Code Rename*) |
| **Acciones de código / Correcciones rápidas** | **`<Space> + ca`** | Menú para importar módulos o corregir errores |
| **Formatear el archivo actual** | **`<Space> + cf`** | Aplica Prettier, Stylua, Ruff/Black, etc. |
| **Ver error / advertencia de la línea** | **`<Space> + cd`** | Muestra el diagnóstico en ventana flotante |
| **Saltar al error siguiente / anterior** | **`]d`** / **`[d`** | Navega por los errores de sintaxis |

### Autocompletado (`blink.cmp`) mientras escribís:
* **`<Tab>`** / **`<S-Tab>`**: Moverse por las sugerencias.
* **`<Enter>`**: Aceptar y autocompletar.
* **`Ctrl + Space`**: Abrir/alternar menú y documentación flotante.
* **`Ctrl + e`**: Cerrar menú de autocompletado.

---

## 8. Documentación Automática, Comentarios y Envolturas

* **Generador de Documentación (`neogen`):**
  - **`<Space> + cn`**: Genera la plantilla de documentación oficial (**JSDoc/TSDoc**, **Google Docstrings**, **LuaDoc**) con parámetros y tipos.
  - **`<Space> + cnc`**: Documentar clase | **`<Space> + cnt`**: Documentar tipo/interfaz.
  - **`<Tab>`**: Salta entre los campos autogenerados para escribir las descripciones.
* **Comentarios Rápidos Multilenguaje (`ts-comments`):**
  - **`gcc`**: Comentar / Descomentar línea actual en modo normal.
  - **`gc`**: Comentar / Descomentar bloque seleccionado en modo visual.
* **Manipulación de Envolturas (`mini.surround`):**
  - **`gsa`**: Envolver palabra (`gsa` + `iw` + `"` $\rightarrow$ `"palabra"`).
  - **`gsd`**: Borrar envoltura (`gsd"` sobre `"hola"` $\rightarrow$ `hola`).
  - **`gsr`**: Reemplazar envoltura (`gsr'"` sobre `'texto'` $\rightarrow$ `"texto"`).

---

## 9. GitLens y Control de Cambios en Vivo

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

## 10. Activación Dinámica de Lenguajes y Plugins (LazyExtras)

| Qué querés hacer | Atajo / Comando | Explicación |
| :--- | :--- | :--- |
| **ACTIVAR / DESACTIVAR LENGUAJES Y EXTRAS**| **`<Space> + px`** (o `:LazyExtras`) | Menú visual con casillas: tocás **`x`** para encender o apagar TypeScript, Python, Docker, Tailwind, Rust, Go, etc. |
| **Dashboard de Plugins (Lazy UI)** | **`<Space> + pl`** (o `:Lazy`) | Ver estado y velocidad de arranque de plugins en ms |
| **Dashboard de Servidores (Mason UI)**| **`<Space> + pm`** (o `:Mason`) | Instalar o actualizar Language Servers y Linters |
| **Restaurar Sesión del Proyecto** | **`<Space> + qs`** | Abre ventanas, pestañas y cursores donde los dejaste |
| **Restaurar Última Sesión de Neovim** | **`<Space> + ql`** | Restaura la última sesión cerrada |
| **Actualizar todos los plugins** | **`<Space> + pu`** | Ejecuta `:Lazy update` |
