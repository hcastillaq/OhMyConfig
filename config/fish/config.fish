# ==============================================================================
# CONFIGURACIÓN DE FISH SHELL (OPTIMIZADA Y DOCUMENTADA)
# ==============================================================================

# --- 1. VARIABLES GLOBALES Y RUTAS (PATH) ---

set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml      # Ruta del archivo de personalización del prompt Starship
set -gx XDG_CONFIG_HOME $HOME/.config                       # Directorio estándar para archivos de configuración en Unix
# Hacer que el autocompletado de Fish sea más visible (Gris azulado claro)
set -g fish_color_autosuggestion 737aa2

# Rutas del sistema gestionadas sin duplicados
fish_add_path /opt/homebrew/bin                             # Binarios principales instalados vía Homebrew (Apple Silicon)
fish_add_path $HOME/.local/bin                              # Binarios y scripts instalados por el usuario
fish_add_path $HOME/.antigravity-ide/antigravity-ide/bin    # Binario del editor de código personalizado


# --- 2. FUNCIONES Y ALIAS ---

# Función utilitaria para macOS
function clean-ds
    find . -name ".DS_Store" -type f -delete                # Elimina recursivamente archivos ocultos .DS_Store del proyecto
end

# Eza (Reemplazo moderno de ls)
alias ls="eza --icons --group-directories-first"             # Lista con íconos agrupando carpetas primero
alias ll="eza -la --icons --group-directories-first"         # Lista detallada (permisos, tamaño, ocultos) con íconos
alias la="eza -a --icons --group-directories-first"          # Lista simple incluyendo archivos ocultos (.env, etc.)
alias tree="eza --tree --icons"                              # Muestra la estructura de carpetas en forma de árbol visual

# Bat (Reemplazo moderno de cat)
alias cat="bat --style=plain"                                # Muestra contenido con resaltado de sintaxis sin bordes pesados

# Git (Atajos de control de versiones)
alias g="git"                                               # Atajo rápido para el comando base de Git
alias gs="git status"                                       # Ver estado de archivos modificados y rama actual
alias gc="git commit"                                       # Crear un nuevo commit
alias gch="git checkout"                                    # Cambiar de rama o restaurar archivos
alias gd="git diff"                                         # Ver diferencias de código pendientes
alias gl="git log --oneline --graph --decorate"             # Ver historial de commits de forma gráfica y compacta
alias gp="git push"                                         # Subir cambios al repositorio remoto
alias gaa="git add ."                                       # Agregar todos los cambios al staging

# LazyGit (Interfaz TUI para Git)
alias lg="lazygit"                                          # Abre la interfaz visual de Git en la terminal

# Editor de código
alias code="agy-ide"                                        # Lanza tu IDE personalizado desde la consola
alias zj="zellij"                                           # Inicia o se une a una sesión de Zellij manualmente

# Zoxide y Navegación (Uso de abreviaturas para autoexpansión)
alias cd="z"                                                # Reemplaza cd con el salto inteligente de zoxide
abbr -a .. "z .."                                           # Sube 1 nivel en las carpetas
abbr -a ... "z ../.."                                       # Sube 2 niveles en las carpetas
abbr -a .... "z ../../.."                                   # Sube 3 niveles en las carpetas
abbr -a - "z -"                                             # Regresa de inmediato al directorio previo


# --- 3. INICIALIZADORES DINÁMICOS ---

mise activate fish | source                                 # Inyecta runtimes (Node, Python, Java, .NET) y variables .env
zoxide init fish | source                                   # Inicializa el motor de base de datos y aprendizaje de zoxide
fzf --fish | source                                         # Habilita atajos interactivos de búsqueda difusa (Ctrl+R, etc.)
starship init fish | source                                 # Renderiza el prompt visual rápido y reactivo
