---
title: OhMyConfig
description: Entorno de desarrollo para macOS con herramientas en Rust/Go y el tema visual Static Noise
template: splash
hero:
  title: OhMyConfig
  tagline: Mi entorno diario para macOS. Herramientas de última generación en Rust y Go, un agente de IA veloz en la terminal y una identidad visual coherente bajo el tema Static Noise.
  actions:
    - text: Comenzar Instalación
      link: /OhMyConfig/instalacion/
      icon: right-arrow
      variant: primary
    - text: Ecosistema AI & Pi
      link: /OhMyConfig/ai/
      icon: external
      variant: secondary
    - text: Tabla de Atajos
      link: /OhMyConfig/cheatsheet/
      variant: minimal
---

<div class="cosmic-feature-grid">
  <a href="/OhMyConfig/ai/" class="feature-card">
    <div class="card-kicker">01 // AUTONOMOUS RUNTIME</div>
    <div class="card-head">
      <span class="card-glyph" style="color: var(--sn-cyan);">✦</span>
      <span class="card-title">Ecosistema AI & Pi</span>
    </div>
    <p class="card-desc">
      Agente Pi en terminal con instalación base mínima. Sin bloatware: sumás extensiones para Compound Engineering, subagentes en paralelo y memoria persistente solo cuando las necesitás.
    </p>
    <div class="card-footer">
      <code>omc dev status</code>
      <span class="card-arrow">→</span>
    </div>
  </a>

  <a href="/OhMyConfig/neovim/" class="feature-card">
    <div class="card-kicker">02 // LUA MODULAR IDE</div>
    <div class="card-head">
      <span class="card-glyph" style="color: var(--sn-blue);">✦</span>
      <span class="card-title">Neovim (LazyVim Core)</span>
    </div>
    <p class="card-desc">
      Mi editor de cabecera. Basado en LazyVim para que la comunidad mantenga los plugins mientras yo personalizo atajos rápidos, autocompletado con Blink.cmp y transparencia para Ghostty.
    </p>
    <div class="card-footer">
      <code>v file.rs</code>
      <span class="card-arrow">→</span>
    </div>
  </a>

  <a href="/OhMyConfig/zellij/" class="feature-card">
    <div class="card-kicker">03 // RUST MULTIPLEXER</div>
    <div class="card-head">
      <span class="card-glyph" style="color: var(--sn-purple);">✦</span>
      <span class="card-title">Multiplexor Zellij</span>
    </div>
    <p class="card-desc">
      Layout limpio con barra inferior de 1 sola línea usando zjstatus local en WASM. Navegación directa con Alt que jamás interfiere con los atajos de Neovim ni de la shell.
    </p>
    <div class="card-footer">
      <code>zj</code>
      <span class="card-arrow">→</span>
    </div>
  </a>

  <a href="/OhMyConfig/terminal/" class="feature-card">
    <div class="card-kicker">04 // METAL ACCELERATION</div>
    <div class="card-head">
      <span class="card-glyph" style="color: var(--sn-green);">✦</span>
      <span class="card-title">Ghostty & Fish Shell</span>
    </div>
    <p class="card-desc">
      Terminal acelerada por GPU con Metal, desenfoque suave y tipografía Nerd Font. Acompañada por Fish Shell para autocompletado en tiempo real e historial SQLite con Atuin.
    </p>
    <div class="card-footer">
      <code>ghostty</code>
      <span class="card-arrow">→</span>
    </div>
  </a>

  <a href="/OhMyConfig/git/" class="feature-card">
    <div class="card-kicker">05 // VISUAL CONTROL</div>
    <div class="card-head">
      <span class="card-glyph" style="color: var(--sn-pink);">✦</span>
      <span class="card-title">Git, Lazygit & Delta</span>
    </div>
    <p class="card-desc">
      Flujo de control de versiones ágil: alias cortos para la rutina, diffs visuales syntax-highlighted con Delta y Lazygit para resolver commits y ramas complejas sin salir de la consola.
    </p>
    <div class="card-footer">
      <code>lg</code>
      <span class="card-arrow">→</span>
    </div>
  </a>

  <a href="/OhMyConfig/instalacion/" class="feature-card">
    <div class="card-kicker">06 // SAFE ENGINE</div>
    <div class="card-head">
      <span class="card-glyph" style="color: var(--sn-orange);">✦</span>
      <span class="card-title">CLI omc & Despliegue</span>
    </div>
    <p class="card-desc">
      Instalador en Bash puro que corre en cualquier Mac de fábrica. Te permite elegir módulos, crear symlinks para editar en vivo y nunca te pisa un archivo sin hacer un backup fechado.
    </p>
    <div class="card-footer">
      <code>./omc install --link</code>
      <span class="card-arrow">→</span>
    </div>
  </a>
</div>

---

## Por qué armé OhMyConfig

Si trabajás todos los días en la terminal, sabés lo frustrante que es lidiar con dotfiles gigantescos que se rompen con cualquier actualización, configuraciones que instalan 50 paquetes que nadie pidió o setups donde cada herramienta tiene una paleta de colores distinta.

OhMyConfig nació con una idea muy simple: **un entorno para macOS rápido, predecible y visualmente armónico**, pensado para que puedas clonar el repo en una máquina nueva y estar programando al instante sin pelear con dependencias.

### Los 3 pilares del proyecto

1. **Rendimiento real con Rust y Go:** Sustituí las utilidades tradicionales de Unix por equivalentes modernos (`eza`, `bat`, `ripgrep`, `dust`, `zoxide`, `zellij`). Responden en microsegundos y aprovechan la aceleración de hardware.
2. **Tema visual Static Noise:** Cero incoherencia visual. Neovim, Zellij, Ghostty, Lazygit y el agente Pi comparten exactamente los mismos tokens cromáticos de alto contraste: negros profundos neutrales (`#0B0D13` y `#11141D`) y acentos en Cyan (`#72EAD5`), Azul (`#83BFFF`) y Púrpura (`#C2A7FF`).
3. **Despliegue seguro e idempotente:** La CLI `omc` está escrita en Bash nativo de macOS (3.2+) para no depender de que tengas Fish o Zsh configurados previamente. Compara tus archivos locales con `cmp -s`, genera copias de seguridad con timestamp antes de modificar nada y te da la opción de usar enlaces simbólicos directos para que cualquier cambio en este repo impacte al momento en tu sistema.
