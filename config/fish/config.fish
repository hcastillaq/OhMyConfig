# ==============================================================================
# CONFIGURACIÓN DE FISH SHELL (TEMA TOKYONIGHT HIGH-CONTRAST PARA FONDOS OSCUROS)
# ==============================================================================

# --- 1. VARIABLES GLOBALES Y ENTORNO ---

set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml      # Ruta de configuración de Starship
set -gx XDG_CONFIG_HOME $HOME/.config                       # Directorio base de configuraciones Unix
set -gx BAT_THEME "tokyonight_night"                        # Tema Tokyonight para bat y delta
set -gx EDITOR "nvim"                                       # Editor de texto predeterminado

# Configuración y colores de FZF (Tokyonight High-Contrast)
set -gx FZF_DEFAULT_OPTS " \
--color=bg+:#283457,bg:#16161e,spinner:#ff007c,hl:#f7768e \
--color=fg:#c0caf5,header:#7aa2f7,info:#7aa2f7,pointer:#7dcfff \
--color=marker:#9ece6a,fg+:#ffffff,prompt:#7dcfff,hl+:#7dcfff \
--prompt '❯ ' --pointer '▶ ' --marker '✓ '"

set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git --exclude node_modules'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git --exclude node_modules'

# ==============================================================================
# PALETA DE SINTAXIS NATIVA DE FISH (ALTO CONTRASTE Y MÁXIMA LUMINOSIDAD)
# ==============================================================================
# 1. Comandos Principales y Palabras Clave
set -g fish_color_command 50f5ff                            # Cyan Neón Eléctrico (#50f5ff) - Máximo brillo y nitidez en negro
set -g fish_color_keyword c099ff --bold                     # Púrpura Tokyonight Luminoso (#c099ff)
set -g fish_color_quote 9ece6a                              # Verde Lima brillante (#9ece6a) para strings/comillas
set -g fish_color_redirection 7dcfff                        # Cyan Claro (#7dcfff) para pipes | y redirecciones >
set -g fish_color_end ff9e64                                # Naranja Brillante (#ff9e64) para ; y &&
set -g fish_color_error f7768e --bold                       # Rojo / Coral (#f7768e) para comandos inválidos o errores

# 2. Argumentos, Opciones y Comentarios
set -g fish_color_normal e0e6fc                             # Blanco Lavanda Brillante (#e0e6fc) para texto general
set -g fish_color_param e0e6fc                              # Argumentos y nombres de archivo en texto nítido
set -g fish_color_option 7aa2f7                             # Flags y opciones (--flag, -l, --all) en Azul Cielo
set -g fish_color_comment 7a88cf                            # Gris Azulado Luminoso (#7a88cf) - 100% legible
set -g fish_color_autosuggestion 636f8f                     # Sugerencias tenues pero con contraste real (#636f8f)
set -g fish_color_operator 50f5ff                           # Operadores matemáticos y lógicos (=, +, *)
set -g fish_color_escape b4f9f8                             # Caracteres de escape (\n, \t, etc.)

# 3. Selección y Búsqueda
set -g fish_color_selection --background=283457             # Fondo azul noche para texto seleccionado
set -g fish_color_search_match --background=3d59a1          # Fondo azul intenso para coincidencias de búsqueda
set -g fish_color_cancel f7768e --reverse                   # Indicador de cancelación con contraste invertido

# 4. Telemetría de Usuario / Prompt
set -g fish_color_cwd 50f5ff                                # Directorio actual en Cyan Neón
set -g fish_color_user 7aa2f7                               # Usuario en Azul
set -g fish_color_host 9ece6a                               # Host en Verde

# 5. Menú de Autocompletado (Fish Pager Dropdown)
set -g fish_pager_color_prefix 50f5ff --bold                # Letras que coinciden en Cyan neón
set -g fish_pager_color_completion e0e6fc                   # Opciones disponibles en Blanco Lavanda
set -g fish_pager_color_description 7a88cf                  # Descripciones de comandos en Gris legible
set -g fish_pager_color_progress 7aa2f7 --bold              # Barra de progreso del menú
set -g fish_pager_color_selected_background --background=3d59a1 # Fondo del ítem seleccionado en Azul Tokyonight
set -g fish_pager_color_selected_prefix 50f5ff --bold       # Prefijo del ítem seleccionado
set -g fish_pager_color_selected_completion ffffff --bold   # Texto del ítem seleccionado en Blanco puro
set -g fish_pager_color_selected_description a9b1d6          # Descripción del ítem seleccionado
set -g fish_pager_color_secondary_background --background=1f2335 # Fondo alternado para filas pares del menú


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


# --- 4. ALIAS Y ABREVIATURAS ---

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
alias v="nvim"
alias code="agy-ide"

# Zoxide (Navegación inteligente)
alias cd="z"
abbr -a .. "z .."
abbr -a ... "z ../.."
abbr -a .... "z ../../.."
abbr -a - "z -"


# --- 5. INICIALIZADORES DINÁMICOS ---

mise activate fish | source
zoxide init fish | source
fzf --fish | source
if command -v atuin >/dev/null 2>&1
    atuin init fish | source
end
starship init fish | source
