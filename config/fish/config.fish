# ==============================================================================
# CONFIGURACIÓN DE FISH SHELL (TEMA STATIC NOISE PARA FONDOS OSCUROS)
# ==============================================================================

# --- 1. VARIABLES GLOBALES Y ENTORNO ---

set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml      # Ruta de configuración de Starship
set -gx XDG_CONFIG_HOME $HOME/.config                       # Directorio base de configuraciones Unix
set -gx BAT_THEME "ansi"                                    # Hereda la paleta ANSI de Ghostty (Static Noise)
set -gx EDITOR "nvim"                                       # Editor de texto predeterminado

# Configuración y colores de FZF (Static Noise)
set -gx FZF_DEFAULT_OPTS " \
--color=bg+:#193C3B,bg:#141720,spinner:#EF7785,hl:#F08BC2 \
--color=fg:#E6E2D6,header:#83BFFF,info:#83BFFF,pointer:#72EAD5 \
--color=marker:#A3D98B,fg+:#E6E2D6,prompt:#72EAD5,hl+:#72EAD5 \
--prompt '❯ ' --pointer '▶ ' --marker '✓ '"

set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git --exclude node_modules'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git --exclude node_modules'

# ==============================================================================
# PALETA DE SINTAXIS NATIVA DE FISH (STATIC NOISE)
# ==============================================================================
# 1. Comandos Principales y Palabras Clave
set -g fish_color_command 72EAD5                            # Cyan (#72EAD5) - Foco y comando principal
set -g fish_color_keyword F08BC2 --bold                     # Pink (#F08BC2) - Keywords de control
set -g fish_color_quote A3D98B                              # Green (#A3D98B) - Strings y rutas válidas
set -g fish_color_redirection 83BFFF                        # Blue (#83BFFF) - Pipes | y redirecciones >
set -g fish_color_end F3A261                                # Orange (#F3A261) - Separadores ; y &&
set -g fish_color_error EF7785 --bold                       # Red (#EF7785) - Errores de sintaxis

# 2. Argumentos, Opciones y Comentarios
set -g fish_color_normal E6E2D6                             # Text (#E6E2D6) - Texto general
set -g fish_color_param E6E2D6                              # Text (#E6E2D6) - Argumentos y parámetros
set -g fish_color_option C2A7FF                             # Purple (#C2A7FF) - Flags y opciones
set -g fish_color_comment 9299AE                            # Muted (#9299AE) - Comentarios legibles
set -g fish_color_autosuggestion 62697B                     # Disabled (#62697B) - Autosugerencias tenues
set -g fish_color_operator 72EAD5                           # Cyan (#72EAD5) - Operadores matemáticos y lógicos
set -g fish_color_escape 83BFFF                             # Blue (#83BFFF) - Caracteres de escape

# 3. Selección y Búsqueda
set -g fish_color_selection --background=193C3B             # cyanDim (#193C3B) - Fondo de texto seleccionado
set -g fish_color_search_match --background=443B25          # yellowDim (#443B25) - Coincidencias de búsqueda
set -g fish_color_cancel EF7785 --reverse                   # Indicador de cancelación

# 4. Telemetría de Usuario / Prompt
set -g fish_color_cwd 83BFFF                                # Directorio actual en Azul
set -g fish_color_user 72EAD5                               # Usuario en Cyan
set -g fish_color_host A3D98B                               # Host en Verde

# 5. Menú de Autocompletado (Fish Pager Dropdown)
set -g fish_pager_color_prefix 72EAD5 --bold                # Letras coincidentes en Cyan
set -g fish_pager_color_completion E6E2D6                   # Opciones disponibles en Text
set -g fish_pager_color_description 9299AE                  # Descripciones en Muted
set -g fish_pager_color_progress 83BFFF --bold              # Barra de progreso en Blue
set -g fish_pager_color_selected_background --background=193C3B # cyanDim (#193C3B)
set -g fish_pager_color_selected_prefix 72EAD5 --bold       # Prefijo seleccionado en Cyan
set -g fish_pager_color_selected_completion E6E2D6 --bold   # Texto seleccionado en Text
set -g fish_pager_color_selected_description C9C8C2          # Descripción seleccionada en TextSoft
set -g fish_pager_color_secondary_background --background=1B1F2A # raised (#1B1F2A) - Fondo alternado


# --- 2. RUTAS DEL SISTEMA (PATH) ---

fish_add_path /opt/homebrew/bin                             # Binarios Homebrew (Apple Silicon)
fish_add_path /usr/local/bin                                # Binarios Homebrew (Intel)
fish_add_path $HOME/.local/bin                              # Binarios de usuario
fish_add_path $HOME/.antigravity-ide/antigravity-ide/bin    # Editor personalizado


# --- 3. FUNCIONES Y WRAPPERS ---

# Limpieza rápida de basura macOS (.DS_Store)
function cds
    find . -name ".DS_Store" -type f -delete
end

# Wrapper de Yazi para cambiar de directorio al salir con 'q'
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if test -f "$tmp"
        set cwd (command cat -- "$tmp")
        if test -n "$cwd" -a "$cwd" != "$PWD"
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end
end

alias cheat="omc"
alias ayuda="omc"


# --- 4. ALIAS Y ABREVIATURAS ---

# Eza (Reemplazo moderno de ls)
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias lt="eza --tree --level=2 --icons"

# Bat (Reemplazo moderno de cat)
alias cat="bat --paging=never"

# Dust (Reemplazo moderno de du)
alias du="dust"

# Zellij (Multiplexor moderno)
alias zj="zellij"

# JQP (Playground interactivo de jq)
alias jqplay="jqp"

# Neovim (Editor de texto)
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Zoxide (Navegación inteligente)
alias ..="z .."
alias ...="z ../.."
alias -="cd -"

# Atajos rápidos de Git
abbr -a g git
abbr -a gs "git status -sb"
abbr -a ga "git add"
abbr -a gc "git commit -m"
abbr -a gp "git push"
abbr -a gl "git pull"
abbr -a gd "git diff"
abbr -a gco "git checkout"
abbr -a gb "git branch"
abbr -a glog "git log --oneline --graph --decorate"
abbr -a glp "git log --oneline --graph --decorate -n 10"

# Abrir archivos/carpetas en Neovim con FZF
abbr -a of "nvim (fzf)"


# --- 5. INICIALIZACIÓN DE HERRAMIENTAS DINÁMICAS ---

if command -v mise >/dev/null 2>&1
    mise activate fish | source
end

if command -v zoxide >/dev/null 2>&1
    zoxide init fish | source
end

if command -v fzf >/dev/null 2>&1
    fzf --fish | source
end

if command -v atuin >/dev/null 2>&1
    atuin init fish | source
end

if command -v starship >/dev/null 2>&1
    starship init fish | source
end
