---
title: "Instalación — CLI omc"
description: "Guía de instalación guiada, modos de despliegue y uso del CLI interactivo omc."
---

Diseñé la CLI `omc` para que configurar una Mac desde cero deje de ser un dolor de cabeza. 

En lugar de obligarte a instalar herramientas previas o cambiar tu shell antes de empezar, el script está escrito en **Bash nativo de macOS (3.2+)** con una interfaz de terminal limpia gracias a **Gum**. Podés clonar el repositorio en una máquina recién formateada y ejecutar el instalador directamente.

---

## 1. Instalación paso a paso

Abrí la aplicación Terminal de macOS y ejecutá:

```bash
git clone https://github.com/hcastillaq/OhMyConfig.git ~/Codigos/OhMyConfig
cd ~/Codigos/OhMyConfig
./omc install
```

El instalador te va a presentar dos pasos interactivos muy sencillos:

### Paso 1: Modo de despliegue

```text
❯ Symlinks (recomendado — cualquier cambio en el repo se refleja en vivo)
  Copia con respaldo (copia estática de los archivos de configuración)
```

> **Mi recomendación:** Elegí **Symlinks**. De esa forma, cuando ajustes un atajo en `config/nvim/` o agregues un alias en `config/fish/`, el cambio impacta inmediatamente en tu sistema sin tener que reinstalar nada.

### Paso 2: Selección de módulos

Elegí exactamente qué herramientas querés que se configuren en tu máquina (espacio para marcar/desmarcar, Enter para confirmar):

```text
• Core         Fish · Starship · mise · Atuin · Nerd Fonts
• Terminal     Ghostty · Zellij
• Editor       Neovim · Git-Delta · Lazygit · gh · Bat · Glow
• Búsqueda     ripgrep · fd · fzf · sd · yazi · zoxide · eza · dust
• CLI / TUI    bottom · procs · xh · jq · jqp · tokei · onefetch
• DevOps       lazydocker · k9s · kubectx / kubens
• AI / Pi      pi (Coding Agent autónomo en terminal)
```

---

## 2. Seguridad primero: nunca te pisa una configuración

Una de mis mayores obsesiones al armar este proyecto fue la seguridad de tus archivos:

1. **Comparación inteligente:** Antes de tocar un archivo en `~/.config/`, `omc` lo compara con el archivo fuente usando `cmp -s`. Si son idénticos, no hace nada.
2. **Backups automáticos:** Si detecta que modificaste un archivo localmente, genera automáticamente una copia de seguridad fechada (`archivo.bak_YYYYMMDD_HHMMSS`) en el mismo directorio antes de reemplazarlo o enlazarlo.
3. **Idempotencia:** Podés correr `./omc install` diez veces seguidas; si no hubo cambios, el resultado será exactamente el mismo sin duplicar configuraciones ni corromper tus herramientas.

---

## 3. Comandos de la CLI `omc`

La CLI incluye todo lo necesario para mantener tu entorno al día:

### `omc install` — Instalación y actualización de módulos

```bash
./omc install                  # Menú interactivo para elegir modo y módulos
./omc install --all            # Instala todos los módulos directamente en modo symlink
./omc install --link           # Menú interactivo forzando enlaces simbólicos
```

### `omc doctor` — Diagnóstico en tiempo real

Te muestra de un vistazo qué herramientas están instaladas, qué versión tienen y si falta alguna dependencia. Es el primer comando que te recomiendo correr si sentís que algo no responde:

```bash
./omc doctor
```

### `omc update` — Actualización integral con un solo comando

Actualiza Homebrew, todas las fórmulas de terminal, las aplicaciones de escritorio (casks) y el agente de IA `pi` en un único paso:

```bash
./omc update
```

### Static Noise — tema compartido

Durante `install` y `update`, `omc` descarga los artefactos generados desde [`hcastillaq/static-noise`](https://github.com/hcastillaq/static-noise) y los guarda en:

```text
~/.cache/ohmyconfig/static-noise/
```

Los módulos de Ghostty, Zellij, Fish, Starship, Bottom, Lazygit, Delta y Pi consumen esos artefactos. Neovim instala [`static-noise.nvim`](https://github.com/hcastillaq/static-noise.nvim) mediante LazyVim.

`omc` no compila ni mantiene colores localmente. En esta etapa beta usa la rama `main` de Static Noise.

---

## 4. Estructura de tu perfil (`.omc-profile`)

Cuando terminás la instalación, `omc` guarda un archivo `.omc-profile` en la raíz del repositorio recordando qué modo elegiste y qué módulos tenés activos:

```toml
deploy_mode=symlink
modules=core terminal editor search cli devops ai
```

Esto permite que futuras actualizaciones o revisiones con `omc doctor` sepan exactamente qué revisar sin tener que preguntarte de nuevo.
