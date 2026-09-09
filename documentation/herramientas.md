# 🧰 Catálogo Maestro de Herramientas CLI & TUI

OhMyConfig sustituye las herramientas tradicionales de Unix por utilidades de última generación escritas principalmente en **Rust** y **Go**, garantizando máximo rendimiento, seguridad de tipos y una estética unificada bajo **Tokyonight Night**.

---

## 1. Runtimes Políglotas & Gestión de Versiones

### **mise — Gestor Universal de Entornos y Lenguajes (Reemplaza nvm, pyenv, rbenv, sdkman)**
`mise` (anteriormente *rtx*) es el motor polyglot en Rust que administra versiones de lenguajes de programación por proyecto o globales de forma instantánea:

* **Instalar un runtime:**
  ```bash
  mise use -g node@lts       # Instala y activa Node.js LTS globalmente
  mise use python@3.12       # Fija Python 3.12 localmente en el directorio actual
  mise use go@latest         # Instala Go
  mise use rust@latest       # Instala Rust
  mise use java@21           # Instala Java OpenJDK 21
  ```
* **Ver herramientas instaladas y versiones activas:**
  ```bash
  mise ls
  ```
* **Instalar todas las dependencias del archivo `.mise.toml` o `.nvmrc`:**
  ```bash
  mise install
  ```
* **Integración:** Activo automáticamente en Fish Shell y visualizado en tiempo real en el prompt de **Starship**.

---

## 2. Búsqueda y Reemplazo en Terminal

### **ripgrep (`rg`) — Reemplazo ultrarrápido de `grep`**
* `rg "termino"`: Busca texto en todo el proyecto en milisegundos respetando `.gitignore`.
* `rg -i "termino"`: Búsqueda insensible a mayúsculas/minúsculas.
* `rg -t ts "interface"`: Buscar solo dentro de archivos TypeScript (`-t py`, `-t rust`, etc.).
* `rg -C 3 "error"`: Muestra 3 líneas de contexto antes y después de cada coincidencia.

### **fd — Reemplazo moderno y legible de `find`**
* `fd <nombre>`: Busca archivos y carpetas por nombre de forma intuitiva.
* `fd -e json`: Encuentra todos los archivos con extensión `.json`.
* `fd -H <nombre>`: Incluye archivos y carpetas ocultas (`.dotfiles`).
* `fd -t d`: Filtra únicamente directorios.
* `fd -e ts -x prettier --write {}`: Ejecuta un comando sobre cada archivo encontrado.

### **sd — Reemplazo intuitivo de `sed`**
* `sd 'viejo' 'nuevo' archivo.txt`: Reemplazo de texto directo sin las complejas flags de sed en macOS.
* `sd 'http://api.v1' 'https://api.v2' src/**/*.ts`: Reemplazo masivo con expresiones regulares.

---

## 3. Navegación, Exploración y Archivos

### **zoxide (`cd` / `z`) — Navegación Inteligente**
* `cd <nombre>`: Salta a cualquier directorio frecuente sin importar cuán profundo esté.
* `zi`: Menú interactivo con FZF para elegir directorios históricos.
* Abreviaturas: `..` (sube 1 nivel), `...` (sube 2 niveles), `-` (vuelve al previo).

### **fzf — Buscador Difuso Interactivo**
* `Ctrl + t`: Búsqueda difusa de archivos con `fd` en la terminal.
* `Alt + c`: Búsqueda difusa y salto directo a carpetas.
* `cat archivo | fzf`: Filtra cualquier stream de texto en la terminal.

### **yazi (`y` / `yz`) — Administrador de Archivos TUI**
* Administrador de archivos asíncrono con vista previa de texto, código e imágenes.
* Usá el alias `y` para que al salir con `q` tu terminal cambie automáticamente al directorio explorado.

### **eza — Reemplazo moderno de `ls` con Íconos**
* `ls`: Lista limpia con íconos de archivo y carpetas agrupadas primero.
* `ll`: Lista detallada completa con permisos, tamaños, fechas y estado de Git (`eza -la`).
* `la`: Lista con archivos ocultos (`eza -a`).
* `tree`: Visualización de carpetas en árbol con íconos (`eza --tree`).

### **bat (`cat`) — Visor de Archivos con Sintaxis**
* `cat <archivo>`: Visor con sintaxis coloreada Tokyonight, marcas de Git y números de línea.

### **glow (`md`) — Renderizador de Markdown**
* `md README.md`: Lee archivos Markdown con formato enriquecido en la consola.

---

## 4. Telemetría de Código y Control de Versiones

### **tokei — Estadísticas de Líneas de Código**
* `tokei`: Analiza el repositorio actual mostrando el conteo exacto de líneas de código, comentarios y líneas en blanco clasificadas por lenguaje de programación.

### **onefetch (`of`) — Radiografía de Repositorios Git**
* `of`: Genera un resumen gráfico con estadísticas de lenguajes, commits, autor principal y licencia.

### **GitHub CLI (`gh`) — Interacción con GitHub en Terminal**
* `gh pr list` / `gh pr create`: Listar o crear Pull Requests desde la consola.
* `gh issue list` / `gh issue create`: Gestionar issues.
* `gh repo view --web`: Abrir el repositorio actual en el navegador.

---

## 5. APIs, Datos y JSON

### **xh — Cliente HTTP Ergonómico (Reemplazo de `curl`)**
* `xh GET api.github.com/users/octocat`
* `xh POST httpbin.org/post name="Gentleman" role="Architect"`
* `xh -b GET https://api.com`: Muestra solo el cuerpo de la respuesta con sintaxis JSON formateada.

### **jq & jqp — Procesamiento y Playground JSON**
* `jq`: Procesamiento y formateo de streams JSON por consola.
* `jqp`: Playground TUI interactivo para probar filtros de `jq` en tiempo real:
  ```bash
  cat respuesta.json | jqp
  ```

---

## 6. Monitoreo del Sistema y Procesos

### **bottom (`btm`) — Monitor de Sistema Gráfico**
* `btm`: Monitor en tiempo real de CPU por núcleo, Memoria/Swap, Red, Discos y Procesos.
* Atajos internos: `t` (ordenar por CPU), `m` (ordenar por Memoria), `dd` (terminar proceso), `/` (filtrar).

### **procs — Reemplazo Enriquecido de `ps`**
* `procs`: Lista de procesos con consumo de memoria, CPU, usuario y PID en colores claros.
* `procs --port 3000`: Muestra qué proceso exacto está utilizando el puerto 3000.
* `procs --tree`: Vista en árbol jerárquico de procesos.

### **dust (`du`) — Uso Gráfico de Disco**
* `du`: Visualizador interactivo del espacio en disco en barras gráficas.
* `du -d 2`: Análisis a 2 niveles de profundidad de carpetas.

---

## 7. Contenedores y Kubernetes

### **lazydocker — TUI para Docker**
* `lazydocker`: Panel visual interactivo para contenedores, imágenes, volúmenes y logs en vivo.

### **k9s — Panel de Control para Kubernetes**
* `k9s`: TUI interactivo para administrar pods, deployments, servicios y logs en vivo de clusters de K8s.

### **kubectx & kubens — Alternador Rápido de Contextos**
* `kubectx`: Cambia entre clusters de Kubernetes al instante.
* `kubens`: Cambia entre namespaces del cluster activo.
