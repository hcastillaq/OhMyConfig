---
title: OhMyConfig
description: Entorno de Desarrollo Moderno y Minimalista para macOS (Static Noise)
template: splash
hero:
  title: OhMyConfig
  tagline: Entorno de desarrollo para macOS con herramientas de última generación en Rust y Go, estilizadas bajo la paleta Static Noise.
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
      Agente Pi autónomo en terminal con instalación base mínima. Extensiones opcionales para Compound Engineering, subagentes en paralelo y memoria persistente.
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
      Entorno Lua modular con autocompletado ultra veloz (Blink.cmp), LSP preconfigurado, formateo automático, GitSigns y generación estructurada de docstrings.
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
      Barra de estado unificada de 1 línea mediante <code>zjstatus.wasm</code> local. Marcos de alto contraste en Cyan y navegación directa entre paneles con <code>Alt</code>.
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
      Terminal nativo con aceleración Metal y desenfoque de GPU. Shell interactiva Fish con prompt reactivo Starship e historial SQLite vía Atuin.
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
      Stack completo de Git con <code>lazygit</code> en TUI, visor visual de diffs sintácticos con <code>git-delta</code> y telemetría de repo con <code>Onefetch</code>.
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
      Instalador interactivo en Bash puro con TUI Gum. Diagnóstico en vivo con <code>doctor</code>, modo symlink para desarrollo y backups automáticos fechados.
    </p>
    <div class="card-footer">
      <code>./omc install --link</code>
      <span class="card-arrow">→</span>
    </div>
  </a>
</div>
