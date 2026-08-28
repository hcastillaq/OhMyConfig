#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
SYMLINK_MODE=false

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        --link|-l)
            SYMLINK_MODE=true
            shift
            ;;
        *)
            echo "Opción desconocida: $1"
            echo "Uso: $0 [--link|-l]"
            exit 1
            ;;
    esac
done

echo "=========================================="
echo "🚀 Iniciando instalación de OhMyConfig"
if [[ "$SYMLINK_MODE" == true ]]; then
    echo "🔗 Modo: Enlaces Simbólicos (Symlinks)"
else
    echo "📁 Modo: Copia Segura con Respaldo"
fi
echo "=========================================="

# 1. Verificar e instalar Homebrew si no está disponible
if ! command -v brew >/dev/null 2>&1; then
    echo "⚠️  Homebrew no encontrado. Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configurar Homebrew en PATH para la sesión actual según la arquitectura
    if [[ -d "/opt/homebrew/bin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/bin" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew detectado."
fi

# 2. Instalar paquetes y herramientas vía Brewfile
echo ""
echo "📦 Instalando herramientas y paquetes desde Brewfile..."
brew bundle --file="${DOTFILES_DIR}/Brewfile"

# 3. Función auxiliar para desplegar archivos de configuración de forma segura
deploy_config() {
    local src="$1"
    local dest="$2"
    local dest_dir
    dest_dir="$(dirname "$dest")"

    # Si el directorio de destino es un symlink previo, removerlo para crear una carpeta real
    if [[ -L "$dest_dir" ]]; then
        echo "🔄 Detectado enlace simbólico en carpeta ${dest_dir}. Reemplazando por directorio real..."
        rm -f "$dest_dir"
    fi
    mkdir -p "$dest_dir"

    if [[ "$SYMLINK_MODE" == true ]]; then
        # Modo Symlink
        if [[ -L "$dest" ]]; then
            rm -f "$dest"
        elif [[ -f "$dest" ]]; then
            echo "💾 Respaldando archivo existente antes de enlazar: ${dest} -> ${dest}.bak_${TIMESTAMP}"
            mv "$dest" "${dest}.bak_${TIMESTAMP}"
        fi
        echo "🔗 Enlazando: ${dest} -> ${src}"
        ln -sf "$src" "$dest"
    else
        # Modo Copia
        if [[ -L "$dest" ]]; then
            echo "🔄 Removiendo enlace simbólico previo en ${dest}..."
            rm -f "$dest"
        elif [[ -f "$dest" ]]; then
            # Si ya existe como archivo real y su contenido es diferente, crear respaldo
            if ! cmp -s "$src" "$dest"; then
                echo "💾 Respaldando configuración existente: ${dest} -> ${dest}.bak_${TIMESTAMP}"
                cp "$dest" "${dest}.bak_${TIMESTAMP}"
            fi
        fi
        echo "📄 Desplegando: ${dest}"
        cp -f "$src" "$dest"
    fi
}

# 4. Desplegar configuraciones
echo ""
echo "⚙️  Configurando archivos en ${CONFIG_DIR}..."

deploy_config "${DOTFILES_DIR}/config/fish/config.fish" "${CONFIG_DIR}/fish/config.fish"
deploy_config "${DOTFILES_DIR}/config/ghostty/config" "${CONFIG_DIR}/ghostty/config"
deploy_config "${DOTFILES_DIR}/config/starship/starship.toml" "${CONFIG_DIR}/starship/starship.toml"
deploy_config "${DOTFILES_DIR}/config/zellij/config.kdl" "${CONFIG_DIR}/zellij/config.kdl"
deploy_config "${DOTFILES_DIR}/config/zellij/layouts/default.kdl" "${CONFIG_DIR}/zellij/layouts/default.kdl"
deploy_config "${DOTFILES_DIR}/config/zellij/plugins/zjstatus.wasm" "${CONFIG_DIR}/zellij/plugins/zjstatus.wasm"
deploy_config "${DOTFILES_DIR}/config/lazygit/config.yml" "${CONFIG_DIR}/lazygit/config.yml"
deploy_config "${DOTFILES_DIR}/config/bottom/bottom.toml" "${CONFIG_DIR}/bottom/bottom.toml"

echo ""
echo "=========================================="
echo "✅ Instalación y configuración completada."
echo "=========================================="
echo ""
echo "💡 Pasos opcionales recomendados:"
echo "1. Establecer Fish como shell por defecto:"
echo "   echo \"\$(which fish)\" | sudo tee -a /etc/shells"
echo "   chsh -s \"\$(which fish)\""
echo "2. Abrir Ghostty para disfrutar del nuevo entorno."
