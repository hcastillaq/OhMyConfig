# OhMyConfig

Configuración base para entornos de desarrollo en macOS empleando utilidades modernas de terminal optimizadas en Rust y Go.

---

## 🚀 Instalación y Configuración Automática

El script `install.sh` es idempotente y seguro frente a configuraciones previas:
1. **Homebrew:** Detecta o instala Homebrew si no está presente en el sistema.
2. **Dependencias:** Instala todas las utilidades declaradas en el `Brewfile`.
3. **Manejo de `.config` existente:**
   - Si los directorios ya existen, los preserva sin tocar otros archivos.
   - Si existían enlaces simbólicos previos (symlinks), los desenlaza para colocar archivos reales.
   - Si existían archivos de configuración previos con contenido distinto, genera un respaldo automático (`.bak_YYYYMMDD_HHMMSS`) antes de sobrescribirlos.

Para ejecutarlo:

```bash
chmod +x install.sh
./install.sh
```

---

## ⚙️ Configuración Manual (Opcional)

Si preferís realizar los pasos por separado:

### 1. Instalar herramientas
```bash
brew bundle --file=Brewfile
```

### 2. Copiar y reemplazar archivos de configuración
```bash
# Crear directorios base en ~/.config si no existen
mkdir -p ~/.config/fish ~/.config/ghostty ~/.config/starship

# Copiar y reemplazar las configuraciones
cp -f config/fish/config.fish ~/.config/fish/config.fish
cp -f config/ghostty/config ~/.config/ghostty/config
cp -f config/starship/starship.toml ~/.config/starship/starship.toml
```

### 3. Establecer Fish como Shell por defecto
```bash
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

---

## 🛠️ Stack y Utilidades Incluidas

### Emulador y Entorno Base
* **`ghostty`**: Terminal nativa acelerada por GPU, con latencia mínima, soporte de ligaduras, íconos y desenfoque nativo de macOS.
* **`fish`**: Shell interactiva moderna con autocompletado inteligente y autosugerencias basadas en historial.
* **`starship`**: Prompt minimalista, configurable y ultrarrápido escrito en Rust. Muestra estado de Git, runtimes activos y contextos de Kubernetes.
* **`mise`**: Administrador unificado de herramientas, runtimes (Node, Python, Java, etc.) y variables de entorno.

### Multiplexor y Ventanas
* **`zellij`**: Alternativa moderna a Tmux con layouts integrados, pestañas flotantes y configuración lista para usar.

### Gestión de Sistema y Procesos
* **`procs`**: Visualizador moderno de procesos con información de puertos, uso de recursos y árbol de procesos.
* **`bottom`**: Monitor interactivo y gráfico de recursos del sistema (CPU, memoria, red y procesos).

### Navegación y Búsqueda
* **`zoxide`**: Reemplazo inteligente de `cd` que aprende de tus hábitos y salta directo a directorios frecuentes.
* **`fzf`**: Buscador difuso ultrarrápido para filtrar historial, archivos y comandos.
* **`eza`**: Alternativa moderna a `ls` con vista de árbol, metadatos estructurados e íconos.
* **`ripgrep`**: Motor de búsqueda de texto ultrarrápido dentro de archivos (reemplazo de `grep`).
* **`fd`**: Alternativa simple, rápida y amigable a `find`.

### Archivos y Control de Versiones
* **`bat`**: Visor de archivos con resaltado de sintaxis e integración con Git (reemplazo de `cat`).
* **`lazygit`**: TUI visual para gestionar ramas, commits, rebase interactivo y resolución de conflictos.
* **`tokei`**: Analizador estadístico de líneas de código por lenguaje.

### Redes, APIs y Datos
* **`xh`**: Cliente HTTP veloz y ergonómico para probar endpoints REST (reemplazo moderno de `curl` y `httpie`).
* **`jq`**: Procesador y extractor de datos JSON en línea de comandos.

### Contenedores y Orquestación
* **`lazydocker`**: TUI para monitoreo y administración interactiva de contenedores, imágenes y volúmenes de Docker.
* **`k9s`**: Panel visual de terminal para inspeccionar, depurar y administrar recursos en Kubernetes.
* **`kubectx` / `kubens`**: Utilidades para alternar instantáneamente entre contextos y namespaces de Kubernetes.
