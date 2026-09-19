---
title: "Terminal, Shell, Prompt y Runtimes"
description: "Ghostty GPU terminal, Fish shell interactiva, prompt Starship y runtime mise."
---

La terminal es el punto de partida de todo mi flujo de trabajo. En lugar de lidiar con configuraciones pesadas de Zsh que tardan dos segundos en abrir una pestaña, combiné cuatro piezas pensadas para responder al instante en macOS:

1. **Ghostty (GPU Metal):** Emulador nativo para macOS con aceleración por hardware, desenfoque suave de ventana y tipografía JetBrains Mono Nerd Font.
2. **Fish Shell:** Shell moderna que te ofrece autocompletado en tiempo real según tu historial sin necesidad de configurar frameworks complejos como Oh My Zsh.
3. **Starship:** Prompt reactivo en Rust que te muestra el directorio, la rama de Git y el runtime activo en milisegundos.
4. **Atuin:** Base de datos SQLite para tu historial, permitiéndote buscar cualquier comando ejecutado hace meses con duración, fecha y directorio.

---

## 1. Ghostty (GPU Terminal)

Emulador de terminal nativo para macOS con aceleración por GPU (Metal):

* **Desenfoque y Transparencia:** Configurado con *blur radius 20*, opacidad al 0.90 y sin marcos de ventana de macOS.
* **Tipografía:** JetBrains Mono Nerd Font con ligaduras de código habilitadas.
* **Cursor:** Estilo bloque en color Cyan Static Noise (`#72EAD5`).
* **Selección:** Fondo atenuado de alto contraste (`#253A43`) con texto marfil (`#E6E2D6`). Los colores se mantienen junto a cada configuración dentro de `modules/`.

---

## 2. Fish Shell

Shell interactiva con autocompletado en tiempo real y coloreado sintáctico calibrado para fondos oscuros:

* **Sintaxis Coloreada:** Comandos en Cyan (`#72EAD5`), comillas en verde (`#A3D98B`), flags y opciones en púrpura (`#C2A7FF`), separadores en naranja (`#F3A261`), errores en rojo (`#EF7785`).
* **Atajos:** La referencia única de alias y atajos está en `documentation/cheatsheet.md`.
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

Prompt ultrarrápido escrito en Rust con telemetría contextual y glifos minimalistas:

* **Directorio actual (`#83BFFF`):** Indica la ruta actual con marcador de solo lectura cuando no hay permisos de escritura.
* **Rama y estado de Git (`#C2A7FF` / `#F3A261`):** Muestra si estás adelantado, atrasado o con cambios pendientes en la rama.
* **Runtimes activos vía mise:** Muestra la versión activa de Node, Python, Java, Rust o Go.
* **Contexto de Kubernetes (`#72EAD5`):** Cluster y namespace activo.
* **Contexto de Docker (`#83BFFF`):** Estado del daemon de contenedores.
* **Duración de comandos (`#EDD071`):** Muestra el tiempo de ejecución si supera los 2 segundos.
* **Carácter de entrada (❯):** Cyan (`#72EAD5`) en comandos exitosos, Rojo (`#EF7785`) si el comando anterior falló.

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
