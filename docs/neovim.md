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
| **Menú de Ventanas y Splits** | **`<Space> + w`** | Despliega opciones visuales de división y control |
| **Mover foco entre ventanas** | **`<Space> + wh/j/k/l`** | Mueve el foco a la ventana izquierda, abajo, arriba o derecha |
| **Dividir ventana horizontalmente** | **`<Space> + ws`** (o `<Space> + w-`) | Crea un nuevo split horizontal inferior |
| **Dividir ventana verticalmente** | **`<Space> + wv`** (o `<Space> + w\|`) | Crea un nuevo split vertical derecho |
| **Cerrar ventana / split activo** | **`<Space> + wd`** (o `<Space> + wq`) | Cierra la ventana actual sin cerrar Neovim |
| **Maximizar / Restaurar tamaño (Zoom)** | **`<Space> + wm`** | Alterna pantalla completa en la ventana activa |
| **Balancear e igualar tamaño** | **`<Space> + w=`** | Ajusta automáticamente todas las ventanas al mismo tamaño |
| **Intercambiar posición (Swap)** | **`<Space> + wx`** | Intercambia posición de la ventana activa con la siguiente |

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
| **Guardar archivo actual** | **`Ctrl + s`** (o `<Space> + fs`) | Guarda los cambios en disco (en modo normal, visual o inserción) |
| **Menú de Ventanas y Splits** | **`<Space> + w`** | Menú interactivo de gestión y división de ventanas |
| **Cerrar pestaña actual limpiamente** | **`<Space> + bd`** | Cierra el archivo sin dejar pestañas `[No Name]` |
| **Cerrar todas las demás pestañas** | **`<Space> + bo`** | Cierra todos los buffers excepto el actual |
| **Siguiente / Anterior pestaña** | **`<Space> + bl`** / **`<Space> + bh`** | Navega por la barra superior de pestañas (`Shift + l/h`) |
| **Alternar con la pestaña previa** | **`<Space> + bb`** | Salta instantáneamente a la última pestaña visitada |
| **Elegir pestaña interactivamente** | **`<Space> + bj`** | Abre selector difuso interactivo de pestañas |
| **Fijar pestaña actual (Pin)** | **`<Space> + bp`** | Fija la pestaña para evitar cerrarla por error |
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

## 7. Inteligencia de Código (LSP), Diagnósticos y Correcciones Automáticas

### A. Tabla de Atajos de Navegación e Inteligencia
| Qué querés hacer | Atajo | Explicación |
| :--- | :--- | :--- |
| **Ir a la definición de una función/variable** | **`gd`** | Salta a donde se creó (*Go to Definition*) |
| **Volver al lugar anterior tras el salto** | **`Ctrl + o`** | Regresa en el historial de saltos (*Jump Back*) |
| **Avanzar de nuevo en el historial** | **`Ctrl + i`** | Avanza en el historial de saltos (*Jump Forward*) |
| **Ir a la implementación o interfaz** | **`gI`** | Salta a la clase o código concreto que la implementa |
| **Ir a la definición de tipo** | **`gy`** | Salta a la declaración del tipo/interfaz (*Type Definition*) |
| **Ver referencias / dónde se usa** | **`gr`** | Lista todos los usos del símbolo con Telescope/Snacks |
| **Buscar palabra bajo el cursor en proyecto** | **`<Space> + sw`** | Búsqueda grep de la palabra actual en archivos |
| **Ver documentación y tipos flotantes** | **`K`** | Muestra el docstring y tipos de la función (*Hover*) |
| **Renombrar símbolo en todo el proyecto** | **`<Space> + cr`** | Renombra la variable/función de forma segura (*Code Rename*) |
| **Acciones de código / Correcciones automáticas**| **`<Space> + ca`** | Menú flotante con soluciones sugeridas (*Code Action*) |
| **Acciones de archivo completo (Organizar)** | **`<Space> + cA`** | Organizar imports o correcciones globales (*Source Action*) |
| **Formatear el archivo actual** | **`<Space> + cf`** | Aplica Prettier, Stylua, Ruff/Black, etc. |
| **Ver error / diagnóstico de la línea** | **`<Space> + cd`** | Muestra el diagnóstico y mensaje de error en ventana flotante |
| **Saltar al error siguiente / anterior** | **`]d`** / **`[d`** | Navega por los errores de sintaxis (*Next/Prev Diagnostic*) |
| **Panel de Diagnósticos del Proyecto (Trouble)**| **`<Space> + xx`** | Abre panel inferior con todos los errores del proyecto |

---

### B. Flujo Paso a Paso: ¿Cómo Aplicar Correcciones Sugeridas por el Lenguaje?

Cuando el editor resalta un error de tipado, un módulo no importado o una advertencia de linting:

```text
┌────────────────────────────────────────────────────────────────────────┐
│ PASO 1: Navegar al error       │  Tocá ]d para saltar al próximo error │
├────────────────────────────────┼───────────────────────────────────────┤
│ PASO 2: Leer el diagnóstico    │  Tocá <Space> + cd (ventana flotante) │
├────────────────────────────────┼───────────────────────────────────────┤
│ PASO 3: Abrir sugerencias      │  Tocá <Space> + ca (Code Actions)     │
├────────────────────────────────┼───────────────────────────────────────┤
│ PASO 4: Aplicar la corrección  │  Elegí la opción y tocá <Enter>       │
└────────────────────────────────┴───────────────────────────────────────┘
```

1. **Saltar al error:** Presioná **`]d`** para mover el cursor directamente a la siguiente advertencia o error en el archivo.
2. **Examinar el detalle:** Presioná **`<Space> + cd`** para leer la descripción detallada del compilador/LSP en una ventana flotante.
3. **Desplegar correcciones sugeridas:** Presioná **`<Space> + ca`** (*Code Action*). Neovim abrirá un menú emergente con las soluciones que el servidor de lenguaje recomienda (ej: *"Import 'UserService'"*, *"Add missing interface members"*, *"Surround with try/catch"*, *"Fix spelling"*).
4. **Aplicar la solución con 1 tecla:** Movete por las sugerencias con **`j` / `k`** (o las flechas) y presioná **`<Enter>`**. Neovim aplicará los cambios en el código al instante sin que tengas que escribirlos a mano.
5. **Organizar imports de todo el archivo:** Presioná **`<Space> + cA`** (*Source Action*) para ejecutar arreglos globales como organizar o limpiar imports no utilizados.
6. **Vista de todos los errores del proyecto:** Presioná **`<Space> + xx`** para abrir el panel de **Trouble**, que agrupa todos los problemas del repositorio por archivo y severidad.

---

### C. Flujo Paso a Paso: Navegar entre Código y Volver sin Perderte

1. **Saltar a la definición:** Colocá el cursor sobre cualquier función, variable o clase y tocá **`gd`** (*Go to Definition*).
2. **Volver al punto original:** Tocá **`Ctrl + o`** (*Jump Out*). Neovim te devolverá de inmediato al archivo y la línea exacta donde estabas antes del salto.
3. **Re-avanzar hacia la definición:** Tocá **`Ctrl + i`** (*Jump In*) para volver a ir hacia adelante en la pila de navegación.
4. **Si estás en una Interfaz:** Tocá **`gI`** (*Go to Implementation*) para saltar a la clase concreta que implementa el método (especialmente útil en Java, TypeScript y Go).
5. **Consultar sin saltar:** Tocá **`K`** (*Hover*) para ver la firma, tipos de parámetros y documentación en una ventana flotante sin mover el cursor.

---

### D. Autocompletado (`blink.cmp`) y Selección Sintáctica:
* **`Ctrl + Space` según el modo:**
  - En **Modo Inserción**: Abre manualmente el menú emergente de sugerencias de autocompletado y documentación flotante.
  - En **Modo Normal / Visual**: Ejecuta selección incremental sintáctica de código con Treesitter (nodo $\rightarrow$ línea $\rightarrow$ bloque).
* **`<Tab>`** / **`<S-Tab>`**: Moverse por las sugerencias de autocompletado.
* **`<Enter>`**: Aceptar y autocompletar la sugerencia seleccionada.
* **`Ctrl + e`**: Cerrar menú de autocompletado sin seleccionar nada.

---

## 8. Documentación Automática, Comentarios y Envolturas

* **Generador de Documentación (`neogen`):**
  - **`<Space> + cn`**: Genera la plantilla de documentación oficial (**JSDoc/TSDoc**, **Google Docstrings**, **LuaDoc**) con parámetros y tipos.
  - **`<Space> + cnc`**: Documentar clase | **`<Space> + cnt`**: Documentar tipo/interfaz.
  - **`<Tab>`**: Salta entre los campos autogenerados para escribir las descripciones.
* **Comentarios Rápidos Multilenguaje (`ts-comments`):**
  - **`<Space> + cc`** (o **`gcc`**): Comentar / Descomentar línea actual en modo normal.
  - **`<Space> + cc`** (o **`gc`** en visual): Comentar / Descomentar bloque seleccionado en modo visual.
  - **`<Space> + cb`**: Añadir una nueva línea comentada debajo de la actual.
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
| **Abrir Lazygit flotante** | **`<Space> + gg`** | Abre interfaz visual completa de Lazygit en Neovim |
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

---

## 11. Soporte de Lenguajes Out-of-the-Box y Runtimes con `mise`

OhMyConfig activa declarativamente soporte para los lenguajes más utilizados en la industria dentro de `config/nvim/lazyvim.json`. Neovim descarga y gestiona automáticamente los Language Servers, parsers Tree-sitter y formatters correspondientes mediante Mason.

| Lenguaje / Framework | Extra de LazyVim | Servidor LSP / Herramientas | SDK / Runtime de Sistema Requerido |
| :--- | :--- | :--- | :--- |
| **TypeScript / JS** | `lang.typescript` | `vtsls`, Prettier, ESLint | Node.js (`mise use -g node@lts`) |
| **Python** | `lang.python` | `pyright` / `basedpyright`, Ruff | Python (`mise use -g python@latest`) |
| **Java** | `lang.java` | `nvim-jdtls`, `java-debug-adapter` | JDK 17 o 21 (`mise use -g java@openjdk-21`) |
| **Go** | `lang.go` | `gopls`, `gofumpt`, Delve (DAP) | Go SDK (`mise use -g go@latest`) |
| **Rust** | `lang.rust` | `rustaceanvim`, `codelldb` | Rust + Analyzer (`mise use -g rust@latest && rustup component add rust-analyzer`) |
| **Angular** | `lang.angular` | `@angular/language-server`, SCSS | Node.js (`mise use -g node@lts`) |
| **PHP** | `lang.php` | `phpactor` (o `intelephense`), PHPCS | PHP CLI (`mise use -g php@latest`) |
| **Docker / YAML / JSON**| `lang.docker`, `lang.yaml`, `lang.json` | Schemas y linters automáticos | Incluidos automáticamente en Mason |

> 💡 **Nota sobre Runtimes y SDKs:** Mason descarga las extensiones y servidores LSP dentro de Neovim, pero servidores como `jdtls` (Java) o `phpactor` (PHP) requieren que el ejecutable base de Java o PHP exista en el sistema (`$PATH`). Si al abrir un archivo Neovim indica que falta un runtime, ejecutá el comando `mise` correspondiente indicado en la tabla.

