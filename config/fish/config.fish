# ==============================================================================
# CONFIGURACIÓN DE FISH SHELL (TEMA TOKYONIGHT UNIFICADO)
# ==============================================================================

# --- 1. VARIABLES GLOBALES Y RUTAS (PATH) ---

set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml      # Ruta de configuración de Starship
set -gx XDG_CONFIG_HOME $HOME/.config                       # Directorio base de configuraciones Unix
set -gx BAT_THEME "tokyonight_night"                        # Tema Tokyonight para bat y delta

# Configuración y colores de FZF (Tema Tokyonight Night)
set -gx FZF_DEFAULT_OPTS " \
--color=bg+:#283457,bg:#16161e,spinner:#ff007c,hl:#f7768e \
--color=fg:#c0caf5,header:#7aa2f7,info:#7aa2f7,pointer:#7dcfff \
--color=marker:#9ece6a,fg+:#c0caf5,prompt:#7dcfff,hl+:#7dcfff \
--prompt '❯ ' --pointer '▶ ' --marker '✓ '"

set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git --exclude node_modules'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git --exclude node_modules'

# Colores de sintaxis nativa de Fish ajustados a Tokyonight Night
set -g fish_color_normal c0caf5
set -g fish_color_command 7aa2f7 --bold
set -g fish_color_keyword bb9af7
set -g fish_color_quote 9ece6a
set -g fish_color_redirection bb9af7
set -g fish_color_end ff9e64
set -g fish_color_error f7768e
set -g fish_color_param c0caf5
set -g fish_color_comment 565f89
set -g fish_color_selection --background=283457
set -g fish_color_search_match --background=3d59a1
set -g fish_color_operator 7dcfff
set -g fish_color_escape bb9af7
set -g fish_color_autosuggestion 565f89
set -g fish_color_cwd 7dcfff
set -g fish_color_user 7aa2f7
set -g fish_color_host 9ece6a
set -g fish_color_cancel f7768e --reverse
set -g fish_pager_color_prefix 7dcfff --bold
set -g fish_pager_color_completion c0caf5
set -g fish_pager_color_description 565f89
set -g fish_pager_color_selected_background --background=283457

# Rutas del sistema gestionadas sin duplicados
fish_add_path /opt/homebrew/bin                             # Binarios Homebrew (Apple Silicon)
fish_add_path /usr/local/bin                                # Binarios Homebrew (Intel)
fish_add_path $HOME/.local/bin                              # Binarios de usuario
fish_add_path $HOME/.antigravity-ide/antigravity-ide/bin    # Editor personalizado


# --- 2. FUNCIONES Y WRAPPERS ---

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


# --- 3. ALIAS Y ABREVIATURAS ---

# Eza (Reemplazo moderno de ls)
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias tree="eza --tree --icons"

# Bat (Reemplazo moderno de cat)
alias cat="bat --style=plain"

# Git
alias g="git"
alias gs="git status"
alias gc="git commit"
alias gch="git checkout"
alias gd="git diff"
alias gl="git log --graph --pretty=format:'%C(bold #7aa2f7)%h%C(reset) - %C(bold #bb9af7)%d%C(reset) %C(#c0caf5)%s%C(reset) %C(#565f89)(%cr)%C(reset) %C(bold #7dcfff)<%an>%C(reset)' --abbrev-commit --date=relative"
alias glog="git log --graph --all --pretty=format:'%C(bold #7aa2f7)%h%C(reset) - %C(bold #bb9af7)%d%C(reset) %C(#c0caf5)%s%C(reset) %C(#565f89)(%cr)%C(reset) %C(bold #7dcfff)<%an>%C(reset)' --abbrev-commit --date=relative"
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
alias code="agy-ide"

# Zoxide (Navegación inteligente)
alias cd="z"
abbr -a .. "z .."
abbr -a ... "z ../.."
abbr -a .... "z ../../.."
abbr -a - "z -"


# --- 4. INICIALIZADORES DINÁMICOS ---

mise activate fish | source
zoxide init fish | source
fzf --fish | source
if command -v atuin >/dev/null 2>&1
    atuin init fish | source
end
starship init fish | source
