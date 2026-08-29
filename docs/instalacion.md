# 🚀 Instalación Rápida & Idempotente

El script `install.sh` automatiza la instalación de paquetes mediante **Homebrew** y el despliegue seguro de configuraciones en `~/.config/`.

---

## 1. Modos de Despliegue

### Opción A: Copia Segura con Respaldo (Por Defecto)
Compara los archivos existentes mediante `cmp -s`. Si detecta modificaciones previas, genera un respaldo automático (`.bak_YYYYMMDD_HHMMSS`) antes de escribir.

```bash
chmod +x install.sh
./install.sh
```

### Opción B: Modo Enlaces Simbólicos (`--link` o `-l`)
Enlaza los directorios de `~/.config/` directamente a este repositorio para desarrollo activo de dotfiles en tiempo real.

```bash
./install.sh --link
# O de forma abreviada:
./install.sh -l
```

---

## 2. Paquetes y Herramientas Gestionadas (`Brewfile`)

El instalador ejecuta automáticamente `brew bundle --file=Brewfile`:

| Categoría | Herramientas |
| :--- | :--- |
| **Terminal & Fuentes** | Ghostty, JetBrains Mono Nerd Font, Symbols Only Nerd Font |
| **Shell & Core** | Fish, Starship, mise (Polyglot runtime manager), Atuin |
| **Multiplexor** | Zellij |
| **Editor Principal** | Neovim |
| **Navegación & Búsqueda** | Zoxide, FZF, Eza, Ripgrep (`rg`), Fd, Yazi, Dust |
| **Git & Telemetría** | Git-Delta, Lazygit, GitHub CLI (`gh`), Glow, Tokei, Onefetch, Sd |
| **APIs & JSON** | Xh, Jq, Jqp |
| **Contenedores & K8s** | Lazydocker, K9s, Kubectx/Kubens |

---

## 3. Pasos Posteriores Recomendados

1. **Establecer Fish como shell por defecto en macOS:**
   ```bash
   echo "$(which fish)" | sudo tee -a /etc/shells
   chsh -s "$(which fish)"
   ```
2. **Abrir Ghostty** para disfrutar del renderizado por GPU y el tema Tokyonight.
