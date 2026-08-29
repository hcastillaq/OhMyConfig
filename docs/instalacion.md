# 🚀 Instalación Rápida & Idempotente

El script `install.sh` automatiza la instalación de paquetes mediante **Homebrew** y el despliegue seguro de configuraciones en `~/.config/`.

---

## 1. Modos de Despliegue

### Opción A: Copia Segura con Respaldo (Por Defecto)
Compara los archivos existentes mediante `cmp -s`. Si detecta modificaciones previas, genera un respaldo automático (`.bak_YYYYMMDD_HHMMSS`) antes de escribir.

```bash
chmod +x install.sh
./install.sh
```

### Opción B: Modo Enlaces Simbólicos (`--link` o `-l`)
Enlaza los directorios de `~/.config/` directamente a este repositorio para desarrollo activo de dotfiles en tiempo real.

```bash
./install.sh --link
# O de forma abreviada:
./install.sh -l
```

---

## 2. Catálogo Completo de Herramientas (`Brewfile`)

El instalador ejecuta automáticamente `brew bundle --file=Brewfile` asegurando la instalación de las siguientes herramientas:

| Categoría | Herramienta | Binario / Comando | Propósito Principal |
| :--- | :--- | :---: | :--- |
| **Terminal** | Ghostty | `ghostty` | Terminal GPU nativo para macOS con blur y aceleración Metal |
| **Tipografía** | JetBrains Mono Nerd Font | — | Fuente monoespaciada con ligaduras de código y glifos v3 |
| **Shell** | Fish Shell | `fish` | Shell interactiva con autocompletado en tiempo real y coloreado |
| **Prompt** | Starship | `starship` | Prompt multi-segmento ultrarrápido en Rust |
| **Runtimes** | mise | `mise` | **Gestor políglota universal** (Node, Python, Go, Rust, Java) |
| **Historial** | Atuin | `atuin` | Base de datos SQLite indexada con búsqueda difusa (`Ctrl + r`) |
| **Multiplexor** | Zellij | `zj` / `zellij` | Multiplexor en Rust con barra 1-línea y navegación directa |
| **Editor IDE** | Neovim | `v` / `nvim` | Editor modal con LazyVim core, LSP, Treesitter y Neogen |
| **Búsqueda Texto** | Ripgrep | `rg` | Búsqueda de texto en todo el proyecto en milisegundos |
| **Búsqueda Archivos**| Fd | `fd` | Búsqueda moderna de archivos y carpetas (reemplazo de `find`) |
| **Buscador Difuso**| FZF | `fzf` | Filtro interactivo para archivos (`Ctrl+t`) y carpetas (`Alt+c`) |
| **Navegación** | Zoxide | `z` / `cd` | Salto inteligente a carpetas frecuentes con memoria de uso |
| **File Manager** | Yazi | `y` / `yazi` | Explorador de archivos TUI asíncrono con vista previa |
| **Listado** | Eza | `ls` / `ll` / `tree` | Reemplazo moderno de `ls` con íconos y marcas de Git |
| **Visor** | Bat | `cat` | Reemplazo de `cat` con sintaxis Tokyonight coloreada |
| **Markdown** | Glow | `md` / `glow` | Visor enriquecido de archivos Markdown en terminal |
| **Reemplazo** | Sd | `sd` | Búsqueda y reemplazo intuitivo con regex (reemplazo de `sed`) |
| **Telemetría Git**| Git-Delta | `delta` | Paginador y resaltador de diffs lado a lado / en línea |
| **Git TUI** | Lazygit | `lg` / `lazygit` | Interfaz visual completa en terminal para Git |
| **GitHub CLI** | GitHub CLI | `gh` | Interacción con Pull Requests, issues y repositorios de GitHub |
| **Telemetría Repo**| Onefetch | `of` / `onefetch` | Radiografía gráfica de estadísticas del repositorio Git |
| **Líneas de Código**| Tokei | `tokei` | Conteo de líneas de código, comentarios y archivos por lenguaje |
| **Cliente HTTP** | Xh | `xh` | Cliente HTTP ergonómico y rápido para APIs (reemplazo de `curl`) |
| **Datos JSON** | Jq | `jq` | Procesador y transformador de streams JSON en consola |
| **JSON TUI** | Jqp | `jqp` | Playground TUI interactivo para probar filtros JQ en vivo |
| **Monitor Sistema**| Bottom | `btm` / `bottom` | Monitor gráfico interactivo de CPU, memoria, discos y red |
| **Procesos** | Procs | `procs` | Visor de procesos enriquecido con búsqueda por puerto |
| **Disco** | Dust | `du` / `dust` | Visualizador de espacio en disco en barras gráficas |
| **Docker TUI** | Lazydocker | `lazydocker` | Panel visual interactivo para contenedores Docker |
| **Kubernetes TUI** | K9s | `k9s` | Panel de control visual interactivo para Kubernetes |
| **Contextos K8s** | Kubectx / Kubens | `kubectx` / `kubens` | Alternador rápido de contextos y namespaces de Kubernetes |

---

## 3. Pasos Posteriores Recomendados

1. **Establecer Fish como shell por defecto en macOS:**
   ```bash
   echo "$(which fish)" | sudo tee -a /etc/shells
   chsh -s "$(which fish)"
   ```
2. **Abrir Ghostty** para disfrutar del renderizado por GPU y el tema Tokyonight.
3. **Instalar tus runtimes con mise:**
   ```bash
   mise use -g node@lts
   mise use -g python@latest
   ```
