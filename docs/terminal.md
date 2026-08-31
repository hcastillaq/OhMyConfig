# Terminal, Shell, Prompt y Runtimes

OhMyConfig combina un emulador acelerado por GPU, una shell interactiva, un gestor de runtimes políglota universal y un prompt reactivo diseñados para macOS.

---

## 1. Ghostty (GPU Terminal)

Emulador de terminal nativo para macOS con aceleración por GPU (Metal):

* **Desenfoque y Transparencia:** Configurado con *blur radius 20*, opacidad al 0.98 y sin marcos de ventana de macOS.
* **Tipografía:** JetBrains Mono Nerd Font con ligaduras de código habilitadas.
* **Cursor:** Estilo bloque en color Cyan Tokyonight (`#7dcfff`).

---

## 2. Fish Shell

Shell interactiva con autocompletado en tiempo real y coloreado sintáctico calibrado para fondos oscuros:

* **Sintaxis Coloreada:** Comandos en Cyan Neón (`#50f5ff`), comillas en verde (`#9ece6a`), flags en azul cielo (`#7aa2f7`), variables en púrpura (`#c099ff`), errores en rojo (`#f7768e`).
* **Función `guia`:** Muestra un mapa interactivo de atajos de todo el sistema categorizado por herramientas (`guia nvim`, `guia zj`, `guia git`, `guia search`, `guia cli`, `guia ai`).
* **Función `cds`:** Purga recursivamente archivos `.DS_Store` en proyectos macOS:
  ```bash
  cds
  ```
* **Wrapper `y` (Yazi):** Al salir del gestor de archivos con `q`, tu terminal cambia automáticamente al directorio donde estabas navegando.

---

## 3. mise — Gestor Políglota de Runtimes y Versiones

`mise` (reemplazo moderno en Rust de `nvm`, `pyenv`, `rbenv`, `sdkman` y `goenv`) gestiona todas las herramientas y lenguajes de desarrollo:

* **Instalación y fijación de versiones globales o por proyecto:**
  ```bash
  mise use -g node@lts       # Node.js LTS global
  mise use python@3.12       # Python 3.12 para el proyecto actual
  mise use go@latest         # Go
  mise use rust@latest       # Rust
  mise use java@21           # Java OpenJDK 21
  ```
* **Ver herramientas y versiones activas:**
  ```bash
  mise ls
  ```
* **Instalación automática:** Lee archivos `.mise.toml`, `.nvmrc` o `.node-version` al entrar a cualquier carpeta.

---

## 4. Starship (Prompt Reactivo)

Prompt ultrarrápido escrito en Rust con telemetría contextual y glifos flat (JetBrains Mono Nerd Font):

* **Directorio actual (`#50f5ff`):** Con indicador de solo lectura ``.
*  **Rama y estado de Git (`#bb9af7` / `#ff9e64`):** Cambios pendientes, commits adelantados/atrasados.
* 󰒋 **Runtimes activos vía mise:** Versión en tiempo real de Node ``, Python ``, Java ``, Rust ``, Go ``.
* 󱃾 **Contexto de Kubernetes (`#7aa2f7`):** Cluster/namespace activo.
*  **Contexto de Docker (`#7aa2f7`):** Daemon/compose activo.
*  **Duración de comandos (`#7a88cf`):** Muestra el tiempo de ejecución si supera los 2 segundos (` 3s`).
* ❯ **Carácter de entrada:** `#50f5ff` (éxito) o `#f7768e` (error).

---

## 5. Atuin (Historial Indexado en SQLite)

Reemplaza el historial tradicional `.bash_history` / `.zsh_history` por una base de datos indexada SQLite con búsqueda difusa:

* Presioná **`Ctrl + r`** o **`↑`** para abrir el buscador interactivo con:
  - Duración exacta de cada comando.
  - Hora y fecha de ejecución.
  - Directorio donde se ejecutó.
  - Código de salida (éxito o error).
* Estadísticas de uso:
  ```bash
  atuin stats
  ```
