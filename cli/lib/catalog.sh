#!/usr/bin/env bash
# ==============================================================================
# CATALOG — Declarative module and tool registry for omc CLI (Bash 3.2+)
# ==============================================================================

export OMC_MODULES=(core terminal editor search cli devops ai)

get_module_label() {
    case "$1" in
        core)     echo "Core" ;;
        terminal) echo "Terminal" ;;
        editor)   echo "Editor" ;;
        search)   echo "Búsqueda" ;;
        cli)      echo "CLI / TUI" ;;
        devops)   echo "DevOps" ;;
        ai)       echo "AI / Pi" ;;
        *)        echo "$1" ;;
    esac
}

get_module_desc() {
    case "$1" in
        core)     echo "Fish · Starship · mise · Atuin · Nerd Fonts" ;;
        terminal) echo "Ghostty · Zellij" ;;
        editor)   echo "Neovim · Git-Delta · Lazygit · gh · Bat · Glow" ;;
        search)   echo "rg · fd · fzf · sd · yazi · zoxide · eza · dust" ;;
        cli)      echo "btm · procs · xh · jq · jqp · tokei · onefetch" ;;
        devops)   echo "lazydocker · k9s · kubectx/kubens" ;;
        ai)       echo "pi (Coding Agent en terminal)" ;;
        *)        echo "" ;;
    esac
}

get_module_tools() {
    case "$1" in
        core)
            cat << 'EOF'
cask:font-jetbrains-mono-nerd-font:font-jetbrains-mono-nerd-font
cask:font-symbols-only-nerd-font:font-symbols-only-nerd-font
brew:fish:fish
brew:starship:starship
brew:mise:mise
brew:atuin:atuin
EOF
            ;;
        terminal)
            cat << 'EOF'
cask:ghostty:ghostty
brew:zellij:zellij
EOF
            ;;
        editor)
            cat << 'EOF'
brew:neovim:nvim
brew:git-delta:delta
brew:lazygit:lazygit
brew:gh:gh
brew:bat:bat
brew:glow:glow
EOF
            ;;
        search)
            cat << 'EOF'
brew:ripgrep:rg
brew:fd:fd
brew:fzf:fzf
brew:sd:sd
brew:yazi:yazi
brew:zoxide:zoxide
brew:eza:eza
brew:dust:dust
EOF
            ;;
        cli)
            cat << 'EOF'
brew:bottom:btm
brew:procs:procs
brew:xh:xh
brew:jq:jq
brew:jqp:jqp
brew:tokei:tokei
brew:onefetch:onefetch
EOF
            ;;
        devops)
            cat << 'EOF'
brew:lazydocker:lazydocker
brew:k9s:k9s
brew:kubectx:kubectx
EOF
            ;;
        ai)
            cat << 'EOF'
npm:@earendil-works/pi-coding-agent:pi
EOF
            ;;
        *)
            echo ""
            ;;
    esac
}

get_module_configs() {
    case "$1" in
        core)
            cat << 'EOF'
fish/config.fish
fish/functions
starship/starship.toml
atuin/config.toml
EOF
            ;;
        terminal)
            cat << 'EOF'
ghostty/config
zellij/config.kdl
zellij/layouts/default.kdl
zellij/plugins/zjstatus.wasm
EOF
            ;;
        editor)
            cat << 'EOF'
nvim
lazygit/config.yml
git/delta.gitconfig
EOF
            ;;
        cli)
            cat << 'EOF'
bottom/bottom.toml
EOF
            ;;
        search|devops|ai)
            echo ""
            ;;
        *)
            echo ""
            ;;
    esac
}
