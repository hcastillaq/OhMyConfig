# ==============================================================================
# BREW — Homebrew helpers for omc commands
# ==============================================================================

# ------------------------------------------------------------------------------
# brew_ensure — verify Homebrew is available, install if missing
# ------------------------------------------------------------------------------
function brew_ensure
    if not command -q brew
        echo "⚠️  Homebrew no encontrado. Instalando..."
        /bin/bash -c (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
        if test -d /opt/homebrew/bin
            eval (/opt/homebrew/bin/brew shellenv)
        else if test -d /usr/local/bin
            eval (/usr/local/bin/brew shellenv)
        end
    end
end

# ------------------------------------------------------------------------------
# brew_pkg_installed — check if a brew formula or cask is installed
# Returns 0 if installed, 1 if not
# Usage: brew_pkg_installed formula ripgrep
#        brew_pkg_installed cask ghostty
# ------------------------------------------------------------------------------
function brew_pkg_installed --argument-names type name
    switch $type
        case cask
            brew list --cask $name &>/dev/null
        case '*'
            brew list --formula $name &>/dev/null
    end
end

# ------------------------------------------------------------------------------
# brew_install_pkg — install a single brew formula or cask
# Usage: brew_install_pkg formula ripgrep
#        brew_install_pkg cask ghostty
# ------------------------------------------------------------------------------
function brew_install_pkg --argument-names type name
    switch $type
        case cask
            brew install --cask $name
        case '*'
            brew install $name
    end
end

# ------------------------------------------------------------------------------
# npm_ensure — verify npm/node is available via mise or system
# ------------------------------------------------------------------------------
function npm_ensure
    if not command -q npm
        echo "⚠️  npm no encontrado. Instalá Node.js con: mise use -g node@lts"
        return 1
    end
end

# ------------------------------------------------------------------------------
# npm_pkg_installed — check if an npm global package is installed
# Returns 0 if installed, 1 if not
# Usage: npm_pkg_installed @earendil-works/pi-coding-agent
# ------------------------------------------------------------------------------
function npm_pkg_installed --argument-names pkg
    npm list -g --depth=0 $pkg &>/dev/null
end

# ------------------------------------------------------------------------------
# npm_pkg_version — get installed version of an npm global package
# Usage: set ver (npm_pkg_version gentle-pi)
# ------------------------------------------------------------------------------
function npm_pkg_version --argument-names pkg
    npm list -g --depth=0 $pkg 2>/dev/null | grep $pkg | string replace -r '.*@' ''
end

# ------------------------------------------------------------------------------
# npm_latest_version — get latest published version of an npm package
# Usage: set latest (npm_latest_version gentle-pi)
# ------------------------------------------------------------------------------
function npm_latest_version --argument-names pkg
    npm show $pkg version 2>/dev/null
end

# ------------------------------------------------------------------------------
# brew_pkg_version — get installed version of a brew formula
# Usage: set ver (brew_pkg_version fish)
# ------------------------------------------------------------------------------
function brew_pkg_version --argument-names name
    brew list --versions $name 2>/dev/null | awk '{print $2}'
end

# ------------------------------------------------------------------------------
# gum_ensure — install gum if not present (bootstraps the TUI itself)
# ------------------------------------------------------------------------------
function gum_ensure
    if not command -q gum
        echo "⚡ Instalando gum (UI de la CLI)..."
        brew install gum
    end
end
