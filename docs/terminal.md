# 🖥️ Terminal, Shell y Prompt

OhMyConfig combina un emulador acelerado por GPU, una shell inteligente y un prompt reactivo diseñados para macOS.

---

## 1. Ghostty (GPU Terminal)

Emulador de terminal nativo para macOS con aceleración por GPU (Metal):

* **Desenfoque y Transparencia:** Configurado con *blur radius 20*, opacidad al 0.98 y sin marcos de ventana de macOS.
* **Tipografía:** JetBrains Mono Nerd Font con ligaduras de código habilitadas.
* **Cursor:** Estilo bloque en color Cyan Tokyonight (`#7dcfff`).

---

## 2. Fish Shell

Shell interactiva con autocompletado en tiempo real y coloreado sintáctico completo:

* **Sintaxis Coloreada:** Comandos en azul (`#7aa2f7`), comillas en verde (`#9ece6a`), variables en púrpura (`#bb9af7`), errores en rojo (`#f7768e`).
* **Función `cds`:** Purga recursivamente archivos `.DS_Store` en proyectos macOS:
  ```bash
  cds
  ```
* **Wrapper `y` (Yazi):** Al salir del gestor de archivos con `q`, tu terminal cambia automáticamente al directorio donde estabas navegando.

---

## 3. Starship (Prompt Reactivo)

Prompt ultrarrápido escrito en Rust con telemetría contextual:

* 📁 **Directorio actual (`#7dcfff`):** Con indicador de solo lectura `🔒`.
*  **Rama y estado de Git (`#bb9af7` / `#ff9e64`):** Cambios pendientes, commits adelantados/atrasados.
* 📦 **Runtimes activos vía mise:** Versión de Node ``, Python ``, Java ``, Rust `🦀`, Go ``.
* ☸️ **Contexto de Kubernetes (`#7aa2f7`).**
* ⏱️ **Duración de comandos:** Muestra el tiempo de ejecución si supera los 2 segundos (`⏳`).
* ❯ **Carácter de entrada:** `#7aa2f7` (éxito) o `#f7768e` (error).

---

## 4. Atuin (Historial Indexado en SQLite)

Reemplaza el historial tradicional `.bash_history` / `.zsh_history` por una base de datos indexada SQLite con búsqueda difusa:

* Presioná **`Ctrl + r`** o **`↑`** para abrir el buscador interactivo con:
  - Duración exacta del comando.
  - Hora y fecha de ejecución.
  - Directorio donde se ejecutó.
  - Código de salida (éxito o error).
* Estadísticas de uso:
  ```bash
  atuin stats
  ```
