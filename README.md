# OhMyConfig

Configuración base para entornos de desarrollo en macOS empleando utilidades modernas de terminal optimizadas en Rust y Go con una estética unificada en **Tokyonight**.

---

## 🚀 Instalación y Configuración Automática

El script `install.sh` es idempotente y seguro frente a configuraciones previas:
1. **Homebrew:** Detecta o instala Homebrew si no está presente en el sistema.
2. **Dependencias:** Instala todas las utilidades y fuentes Nerd Font declaradas en el `Brewfile`.
3. **Manejo de `.config` existente:**
   - Si los directorios ya existen, los preserva sin tocar otros archivos.
   - Si existían archivos de configuración previos con contenido distinto, genera un respaldo automático (`.bak_YYYYMMDD_HHMMSS`) antes de sobrescribirlos.
   - Admite modo de enlace simbólico (`--link` o `-l`) si preferís que `~/.config` apunte directamente a este repositorio.

### Ejecución estándar (Copia segura con respaldo)
```bash
chmod +x install.sh
./install.sh
```

### Ejecución en modo desarrollo (Symlinks directos)
```bash
./install.sh --link
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
mkdir -p ~/.config/fish ~/.config/ghostty ~/.config/starship ~/.config/zellij ~/.config/lazygit ~/.config/bottom

# Copiar y reemplazar las configuraciones
cp -f config/fish/config.fish ~/.config/fish/config.fish
cp -f config/ghostty/config ~/.config/ghostty/config
cp -f config/starship/starship.toml ~/.config/starship/starship.toml
cp -f config/zellij/config.kdl ~/.config/zellij/config.kdl
cp -f config/lazygit/config.yml ~/.config/lazygit/config.yml
cp -f config/bottom/bottom.toml ~/.config/bottom/bottom.toml
```

### 3. Establecer Fish como Shell por defecto
```bash
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

---

## 🛠️ Herramientas, Propósito y Ejemplos de Uso

---

### 🖥️ Emulador, Shell y Fuentes

#### **Ghostty**
* **¿Para qué sirve?** Emulador de terminal nativo para macOS con aceleración por GPU, latencia ultra baja, soporte para ligaduras tipográficas y desenfoque nativo.
* **Uso:** Se lanza como aplicación de macOS (`Ghostty.app`) o desde terminal:
  ```bash
  open -a Ghostty
  ```

#### **JetBrains Mono Nerd Font & Symbols Only**
* **¿Para qué sirve?** Fuentes tipográficas parcheadas con miles de glifos e íconos necesarios para renderizar correctamente prompts, carpetas y estados de Git en Starship, Eza y Lazygit.
* **Uso:** Configuradas automáticamente en el emulador de terminal (`font-family = "Dank Mono"` o `"JetBrainsMono Nerd Font"`).

#### **Fish Shell**
* **¿Para qué sirve?** Shell interactiva moderna con resaltado de sintaxis al escribir, sugerencias basadas en historial y autocompletado inteligente sin configuración pesada.
* **Ejemplos de uso:**
  ```bash
  # Escribí cualquier comando y presioná Flecha Derecha (→) para autocompletar la sugerencia gris
  git che[→]  # autocompleta 'git checkout'
  ```

#### **Starship**
* **¿Para qué sirve?** Prompt minimalista y ultrarrápido escrito en Rust. Muestra de forma reactiva el directorio actual, rama y estado de Git, runtimes activos (Node, Python, Java) y contexto de Kubernetes.
* **Ejemplos de uso:**
  ```bash
  # Ver el tiempo de respuesta o configurar módulos
  starship explain
  starship timings
  ```

#### **mise**
* **¿Para qué sirve?** Administrador políglota de versiones y runtimes de lenguajes (Node, Python, Go, Rust, Java, etc.) y variables de entorno por proyecto, reemplazando a `nvm`, `pyenv`, `sdkman`, etc.
* **Ejemplos de uso:**
  ```bash
  # Instalar y fijar una versión de Node y Python en el proyecto actual
  mise use node@20
  mise use python@3.12

  # Listar versiones instaladas y activas
  mise ls

  # Ejecutar un comando con un runtime específico sin instalarlo globalmente
  mise exec node@18 -- node app.js
  ```

---

### 🪟 Multiplexor de Terminal

#### **Zellij**
* **¿Para qué sirve?** Multiplexor de terminal en Rust (alternativa moderna a Tmux) con pestañas, paneles flotantes, layouts predefinidos y menús de ayuda integrados en pantalla.
* **Ejemplos de uso:**
  ```bash
  # Iniciar o reconectar sesión (alias: zj)
  zj
  zellij attach mi-sesion

  # Atajos clave dentro de Zellij:
  # Ctrl + p  -> Modo Paneles (n = nuevo, x = cerrar, f = flotante/fullscreen)
  # Ctrl + t  -> Modo Pestañas (n = nueva pestaña, 1-9 = cambiar pestaña)
  # Ctrl + d  -> Desconectar sesión sin cerrarla
  ```

---

### 📊 Monitoreo y Procesos

#### **procs**
* **¿Para qué sirve?** Reemplazo moderno y legible de `ps` que colorea la salida, muestra puertos TCP/UDP asociados a cada proceso y árbol jerárquico de ejecución.
* **Ejemplos de uso:**
  ```bash
  # Buscar procesos por nombre
  procs node

  # Ver qué proceso está escuchando en un puerto específico
  procs --port 3000

  # Ver árbol jerárquico de procesos
  procs --tree
  ```

#### **bottom (`btm`)**
* **¿Para qué sirve?** Monitor interactivo de recursos del sistema (CPU por núcleo, RAM/Swap, Red, Discos y Procesos) con gráficos en tiempo real en la terminal.
* **Ejemplos de uso:**
  ```bash
  # Abrir monitor gráfico interactivo (alias: btm)
  btm

  # Dentro de bottom:
  # 't' -> ordenar procesos por uso de CPU
  # 'm' -> ordenar procesos por uso de Memoria
  # 'dd' -> matar proceso seleccionado
  # '/' -> filtrar procesos
  ```

#### **dust (`du`)**
* **¿Para qué sirve?** Analizador visual interactivo de uso de disco en Rust. Permite identificar instantáneamente qué archivos o carpetas están consumiendo más espacio.
* **Ejemplos de uso:**
  ```bash
  # Analizar la carpeta actual (alias: du)
  dust

  # Limitar la profundidad de análisis a 2 niveles
  dust -d 2

  # Analizar un directorio específico mostrando los 10 elementos más pesados
  dust -n 10 /Users/usuario/Downloads
  ```

---

### 🔍 Navegación, Archivos y Búsqueda

#### **zoxide (`cd` / `z`)**
* **¿Para qué sirve?** Reemplazo inteligente de `cd` que aprende de los directorios a los que accedes con frecuencia y te permite saltar a ellos con coincidencias parciales.
* **Ejemplos de uso:**
  ```bash
  # Saltar a un proyecto profundo sin escribir toda la ruta
  cd OhMyConfig      # Salta directo a ~/Codigos/OhMyConfig

  # Selección interactiva con FZF si hay varias coincidencias
  zi

  # Atajos rápidos incluidos en la config:
  ..     # Sube 1 nivel
  ...    # Sube 2 niveles
  -      # Vuelve al directorio anterior
  ```

#### **fzf**
* **¿Para qué sirve?** Motor de búsqueda difusa interactivo para filtrar rápidamente texto, archivos, comandos del historial o procesos.
* **Ejemplos de uso:**
  ```bash
  # Atajos de teclado en Fish:
  # Ctrl + r -> Buscar en el historial de comandos
  # Ctrl + t -> Buscar archivos recursivamente e insertar la ruta
  # Alt + c  -> Cambiar de directorio mediante búsqueda difusa

  # Filtrar cualquier comando mediante tubería (pipe)
  git branch | fzf | xargs git checkout
  ```

#### **yazi (`y` / `yz`)**
* **¿Para qué sirve?** Administrador de archivos TUI ultrarrápido con arquitectura asíncrona en Rust. Soporta vista previa de código, imágenes (en Ghostty) y cambia el directorio de la consola al salir.
* **Ejemplos de uso:**
  ```bash
  # Abrir explorador (al presionar 'q' te deja ubicado en la carpeta donde navegaste)
  y

  # Abrir explorando una ruta puntual
  y ~/Downloads

  # Atajos dentro de Yazi:
  # Espacio -> Seleccionar archivo
  # Enter   -> Abrir archivo en tu editor
  # y / d / p -> Copiar / Cortar / Pegar
  ```

#### **eza (`ls`, `ll`, `la`, `tree`)**
* **¿Para qué sirve?** Reemplazo moderno de `ls` con soporte para íconos, agrupamiento de directorios, permisos legibles y vistas de árbol.
* **Ejemplos de uso:**
  ```bash
  ls             # Lista con íconos agrupando carpetas primero
  ll             # Lista detallada (permisos, tamaño, fechas, archivos ocultos)
  tree           # Vista en árbol visual de la estructura de directorios
  eza --git -l   # Lista archivos mostrando su estado individual en Git
  ```

#### **ripgrep (`rg`)**
* **¿Para qué sirve?** El buscador de texto dentro de archivos más rápido del ecosistema, respetando `.gitignore` por defecto.
* **Ejemplos de uso:**
  ```bash
  # Buscar una palabra o regex en todos los archivos del proyecto
  rg "STARSHIP_CONFIG"

  # Buscar solo dentro de archivos de un tipo de lenguaje
  rg --type rust "fn main"
  rg --type ts "interface User"

  # Buscar ignorando mayúsculas/minúsculas
  rg -i "tokyonight"
  ```

#### **fd**
* **¿Para qué sirve?** Alternativa intuitiva y ultrarrápida a `find` para localizar archivos y directorios por nombre.
* **Ejemplos de uso:**
  ```bash
  # Buscar archivos por extensión
  fd -e fish
  fd -e toml

  # Buscar archivos cuyo nombre contenga un patrón
  fd config

  # Ejecutar un comando sobre todos los archivos encontrados
  fd -e png -x optipng {}
  ```

---

### 📝 Archivos, Git y Documentación

#### **bat (`cat`)**
* **¿Para qué sirve?** Reemplazo de `cat` con resaltado de sintaxis para cientos de lenguajes, integración con Git (muestra líneas agregadas/modificadas al costado) y paginado automático.
* **Ejemplos de uso:**
  ```bash
  cat config/fish/config.fish   # Muestra el archivo con resaltado de sintaxis Tokyonight
  bat -A package.json           # Muestra caracteres no imprimibles (espacios, tabs)
  ```

#### **git-delta**
* **¿Para qué sirve?** Paginador visual para `git diff`, `git log` y `git show` que resalta cambios a nivel de palabra, soporta vista lado a lado (`side-by-side`) y se integra con Lazygit.
* **Ejemplos de uso:**
  ```bash
  git diff                      # Muestra diffs enriquecidos con sintaxis en la terminal
  git diff | delta --side-by-side  # Comparación en dos columnas
  ```

#### **lazygit (`lg`)**
* **¿Para qué sirve?** Interfaz TUI completa para Git. Permite realizar staging de líneas individuales, resolver conflictos de merge, hacer rebase interactivo y navegar ramas sin memorizar comandos complejos.
* **Ejemplos de uso:**
  ```bash
  lg                            # Abre la interfaz visual de Git

  # Atajos dentro de Lazygit:
  # Espacio -> Stage / Unstage de archivo o fragmento
  # c       -> Escribir commit
  # P / p   -> Push / Pull
  # b       -> Menú de ramas (crear, checkout, merge)
  # r       -> Rebase interactivo
  ```

#### **gh (GitHub CLI)**
* **¿Para qué sirve?** Interfaz oficial de línea de comandos para interactuar con GitHub (crear PRs, clonar repositorios, revisar issues, disparar GitHub Actions).
* **Ejemplos de uso:**
  ```bash
  # Crear un Pull Request interactivo con descripción
  gh pr create

  # Ver y revisar PRs abiertos
  gh pr list
  gh pr checkout 42

  # Clonar un repositorio por nombre de usuario/repo
  gh repo clone earendil-works/pi-coding-agent
  ```

#### **glow (`md`)**
* **¿Para qué sirve?** Renderizador de archivos Markdown en la terminal con formato enriquecido, tablas legibles y bloques de código coloreados.
* **Ejemplos de uso:**
  ```bash
  # Leer el README con estilos en consola (alias: md)
  md README.md

  # Leer documentación desde un repositorio remoto
  glow github.com/charmbracelet/glow
  ```

#### **tokei**
* **¿Para qué sirve?** Analizador estadístico que cuenta rápidamente líneas de código, comentarios y líneas en blanco clasificadas por lenguaje.
* **Ejemplos de uso:**
  ```bash
  # Analizar todo el repositorio actual
  tokei

  # Excluir carpetas pesadas como dependencias
  tokei ./ --exclude node_modules --exclude target
  ```

---

### 🌐 Redes, APIs y Datos

#### **xh**
* **¿Para qué sirve?** Cliente HTTP ergonómico y veloz (reemplazo moderno de `curl` y `httpie`) con resaltado de sintaxis de respuestas, soporte nativo de JSON y autenticación simplificada.
* **Ejemplos de uso:**
  ```bash
  # Petición GET simple
  xh https://api.github.com/users/octocat

  # Petición POST enviando JSON automáticamente
  xh POST https://httpbin.org/post name="Gentleman" role="Architect"

  # Enviar encabezados y parámetros de consulta
  xh GET api.example.com/search q==rust Authorization:"Bearer token123"
  ```

#### **jq**
* **¿Para qué sirve?** Procesador y transformador de datos JSON en consola (filtrar campos, mapear arrays, formatear).
* **Ejemplos de uso:**
  ```bash
  # Formatear y colorear un JSON crudo
  curl -s https://api.github.com/repos/fish-shell/fish-shell | jq .

  # Extraer un campo específico
  xh https://api.github.com/repos/bootandy/dust | jq '.stargazers_count'

  # Mapear nombres de un array
  cat data.json | jq '.[].name'
  ```

---

### 🐳 Contenedores y Kubernetes

#### **lazydocker**
* **¿Para qué sirve?** Interfaz TUI para monitorear y administrar contenedores, imágenes, volúmenes y redes de Docker en tiempo real sin escribir largos comandos de `docker exec` o `docker logs`.
* **Ejemplos de uso:**
  ```bash
  lazydocker                    # Inicia la interfaz interactiva

  # Dentro de lazydocker:
  # Enter   -> Ver logs en tiempo real del contenedor
  # m       -> Ver consumo de CPU/Memoria del contenedor
  # d       -> Pausar / Iniciar / Reiniciar contenedor
  ```

#### **k9s**
* **¿Para qué sirve?** Panel visual de terminal para inspeccionar, depurar y administrar clusters de Kubernetes en tiempo real (Pods, Deployments, Logs, Shell interactivo).
* **Ejemplos de uso:**
  ```bash
  k9s                           # Conectar al contexto activo de Kubernetes

  # Dentro de k9s:
  # :pods        -> Ver todos los pods
  # l            -> Ver logs del pod seleccionado
  # s            -> Abrir shell interactivo dentro del contenedor
  # d            -> Describir recurso (describe)
  ```

#### **kubectx & kubens**
* **¿Para qué sirve?** Utilidades rápidas para alternar entre clusters (contextos) y namespaces de Kubernetes sin escribir `kubectl config use-context`.
* **Ejemplos de uso:**
  ```bash
  # Alternar de cluster interactivo
  kubectx
  kubectx prod-cluster

  # Alternar de namespace interactivo
  kubens
  kubens kube-system
  ```

---

## 📑 Resumen de Alias y Atajos Rápidos (Fish)

| Alias / Atajo | Comando Real | Descripción |
| :--- | :--- | :--- |
| `ls` | `eza --icons --group-directories-first` | Lista limpia con íconos |
| `ll` | `eza -la --icons --group-directories-first` | Lista detallada completa |
| `tree` | `eza --tree --icons` | Árbol de carpetas |
| `cat` | `bat --style=plain` | Visor con sintaxis Tokyonight |
| `g` / `gs` / `gc` | `git` / `git status` / `git commit` | Atajos esenciales de Git |
| `lg` | `lazygit` | TUI visual para Git |
| `zj` | `zellij` | Multiplexor de terminal |
| `y` | `yazi (wrapper cwd)` | File manager con salto al salir |
| `yz` | `yazi` | File manager directo |
| `du` | `dust` | Uso gráfico de disco |
| `btm` | `bottom` | Monitor de recursos y CPU |
| `md` | `glow` | Renderizador de Markdown |
| `clean-ds` | `find . -name ".DS_Store" -delete` | Limpieza de basura en macOS |
| `..` / `...` | `z ..` / `z ../..` | Subir 1 o 2 niveles de carpeta |
| `-` | `z -` | Volver al directorio anterior |
| `Ctrl + r` | `fzf history` | Búsqueda difusa en el historial |
