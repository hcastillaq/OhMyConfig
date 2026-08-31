# ==============================================================================
# CATALOG — Declarative module and tool registry for omc CLI
# ==============================================================================
# Format per tool: "type:package[:binary]"
#   brew:ripgrep        → brew install ripgrep   (binary = ripgrep)
#   brew:ripgrep:rg     → brew install ripgrep   (binary = rg)
#   cask:ghostty        → brew install --cask ghostty
#   npm:gentle-pi       → npm install -g gentle-pi
# ==============================================================================

# ------------------------------------------------------------------------------
# MODULE: core
# Fish shell, prompt, runtime manager, shell history
# ------------------------------------------------------------------------------
set -g omc_module_core_label   "Core"
set -g omc_module_core_desc     "Fish · Starship · mise · Atuin · Nerd Fonts"
set -g omc_module_core_tools \
    "cask:font-jetbrains-mono-nerd-font:font-jetbrains-mono-nerd-font" \
    "cask:font-symbols-only-nerd-font:font-symbols-only-nerd-font" \
    "brew:fish:fish" \
    "brew:starship:starship" \
    "brew:mise:mise" \
    "brew:atuin:atuin"
set -g omc_module_core_configs \
    "fish/config.fish" \
    "fish/functions" \
    "starship/starship.toml" \
    "atuin/config.toml"

# ------------------------------------------------------------------------------
# MODULE: terminal
# GPU terminal emulator and multiplexer
# ------------------------------------------------------------------------------
set -g omc_module_terminal_label "Terminal"
set -g omc_module_terminal_desc  "Ghostty · Zellij"
set -g omc_module_terminal_tools \
    "cask:ghostty:ghostty" \
    "brew:zellij:zellij"
set -g omc_module_terminal_configs \
    "ghostty/config" \
    "zellij/config.kdl" \
    "zellij/layouts/default.kdl" \
    "zellij/plugins/zjstatus.wasm"

# ------------------------------------------------------------------------------
# MODULE: editor
# Neovim (LazyVim core), Git toolchain, file viewers
# ------------------------------------------------------------------------------
set -g omc_module_editor_label  "Editor"
set -g omc_module_editor_desc   "Neovim · Git-Delta · Lazygit · gh · Bat · Glow"
set -g omc_module_editor_tools \
    "brew:neovim:nvim" \
    "brew:git-delta:delta" \
    "brew:lazygit:lazygit" \
    "brew:gh:gh" \
    "brew:bat:bat" \
    "brew:glow:glow"
set -g omc_module_editor_configs \
    "nvim" \
    "lazygit/config.yml" \
    "git/delta.gitconfig"

# ------------------------------------------------------------------------------
# MODULE: search
# Navigation, fuzzy finding, file search and replacement
# ------------------------------------------------------------------------------
set -g omc_module_search_label  "Búsqueda"
set -g omc_module_search_desc   "rg · fd · fzf · sd · yazi · zoxide · eza · dust"
set -g omc_module_search_tools \
    "brew:ripgrep:rg" \
    "brew:fd:fd" \
    "brew:fzf:fzf" \
    "brew:sd:sd" \
    "brew:yazi:yazi" \
    "brew:zoxide:zoxide" \
    "brew:eza:eza" \
    "brew:dust:dust"
set -g omc_module_search_configs ""

# ------------------------------------------------------------------------------
# MODULE: cli
# System monitoring, APIs, data processing, code stats
# ------------------------------------------------------------------------------
set -g omc_module_cli_label     "CLI / TUI"
set -g omc_module_cli_desc      "btm · procs · xh · jq · jqp · tokei · onefetch"
set -g omc_module_cli_tools \
    "brew:bottom:btm" \
    "brew:procs:procs" \
    "brew:xh:xh" \
    "brew:jq:jq" \
    "brew:jqp:jqp" \
    "brew:tokei:tokei" \
    "brew:onefetch:onefetch"
set -g omc_module_cli_configs \
    "bottom/bottom.toml"

# ------------------------------------------------------------------------------
# MODULE: devops
# Docker and Kubernetes TUI tools
# ------------------------------------------------------------------------------
set -g omc_module_devops_label  "DevOps"
set -g omc_module_devops_desc   "lazydocker · k9s · kubectx/kubens"
set -g omc_module_devops_tools \
    "brew:lazydocker:lazydocker" \
    "brew:k9s:k9s" \
    "brew:kubectx:kubectx"
set -g omc_module_devops_configs ""

# ------------------------------------------------------------------------------
# MODULE: ai
# Pi coding agent (CLI base)
# ------------------------------------------------------------------------------
set -g omc_module_ai_label      "AI / Pi"
set -g omc_module_ai_desc       "pi (Coding Agent en terminal)"
set -g omc_module_ai_tools \
    "npm:@earendil-works/pi-coding-agent:pi"
set -g omc_module_ai_configs ""

# ------------------------------------------------------------------------------
# Module registry — ordered list for display and iteration
# ------------------------------------------------------------------------------
set -g omc_modules core terminal editor search cli devops ai

# ------------------------------------------------------------------------------
# omc_get — retrieve a module variable by name dynamically
# Usage: set value (omc_get core tools)
#        set value (omc_get terminal label)
# ------------------------------------------------------------------------------
function omc_get --argument-names mod key
    set -l varname "omc_module_"$mod"_"$key
    eval "echo \$$varname"
end

# omc_get_list — retrieve a list variable (returns newline-separated values)
function omc_get_list --argument-names mod key
    set -l varname "omc_module_"$mod"_"$key
    eval "set -l result \$$varname; for v in \$result; echo \$v; end"
end
