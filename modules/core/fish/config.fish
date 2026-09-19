# ==============================================================================
# CONFIGURACIÓN DE FISH SHELL (TEMA STATIC NOISE PARA FONDOS OSCUROS)
# ==============================================================================

# --- 1. VARIABLES GLOBALES Y ENTORNO ---

set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml      # Ruta de configuración de Starship
set -gx XDG_CONFIG_HOME $HOME/.config                       # Directorio base de configuraciones Unix
set -gx BAT_THEME "ansi"                                    # Hereda la paleta ANSI de Ghostty (Static Noise)
set -gx EDITOR "nvim"                                       # Editor de texto predeterminado

# Static Noise se mantiene localmente en OhMyConfig.
set -l static_noise_colors "$XDG_CONFIG_HOME/fish/static-noise-colors.fish"
if test -f "$static_noise_colors"
    source "$static_noise_colors"
end

set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git --exclude node_modules'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git --exclude node_modules'

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
alias ll="eza -la --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias tree="eza --tree --icons"

# Bat (Reemplazo moderno de cat)
alias cat="bat --style=plain"

# Git (Static Noise visual log)
alias g="git"
alias gs="git status"
alias gc="git commit"
alias gch="git checkout"
alias gd="git diff"
alias gl="git log --graph --pretty=format:'%C(bold #72EAD5)%h%C(reset) - %C(bold #C2A7FF)%d%C(reset) %C(#E6E2D6)%s%C(reset) %C(#9299AE)(%cr)%C(reset) %C(bold #83BFFF)<%an>%C(reset)' --abbrev-commit --date=relative"
alias glog="git log --graph --all --pretty=format:'%C(bold #72EAD5)%h%C(reset) - %C(bold #C2A7FF)%d%C(reset) %C(#E6E2D6)%s%C(reset) %C(#9299AE)(%cr)%C(reset) %C(bold #83BFFF)<%an>%C(reset)' --abbrev-commit --date=relative"
alias glp="git log -p"                                      # Log completo con diffs coloreados vía Delta
alias gp="git push"
alias gaa="git add ."
alias of="onefetch"                                         # Resumen visual de repositorio Git

# TUI & Herramientas
alias lg="lazygit"
alias zj="zellij"
alias yz="yazi"
alias du="dust"
alias btm="bottom"
alias md="glow"

# Editor
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Zoxide (Navegación inteligente)
alias cd="z"
abbr -a .. "z .."
abbr -a ... "z ../.."
abbr -a .... "z ../../.."
abbr -a - "z -"

# JQP (Playground interactivo de jq)
alias jqplay="jqp"


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
