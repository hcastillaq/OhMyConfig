---
name: docs-sync-and-build
description: "Trigger: actualizar docs, nueva guia, docs sync, vitepress build, sincronizar documentacion. Sincroniza guías, cheatsheets y valida la compilación con VitePress."
---

# Docs Sync and Build Skill

Esta skill define el protocolo para mantener la documentación de **OhMyConfig** sincronizada, libre de enlaces rotos y validada antes de cualquier despliegue a **GitHub Pages**.

---

## Arquitectura de la Documentación

```text
docs/                        # Fuentes puras en Markdown
├── index.md                 # Landing page con hero y feature cards
├── instalacion.md           # Guía de la CLI omc y Brewfile
├── ai.md                    # Ecosistema de IA (pi, lazypi, compound engineering, plan)
├── neovim.md                # Guía del editor Neovim y LazyVim
├── zellij.md                # Multiplexor Zellij y modo Move
├── git.md                   # Flujo de Git, Lazygit y Delta
├── terminal.md              # Ghostty, Fish, Starship y Atuin
├── herramientas.md          # Catálogo completo de CLI/TUI
└── cheatsheet.md            # Tabla maestra consolidada de atajos

.vitepress/config.mjs        # Configuración del sitio (nav, sidebar, Tokyonight theme)
README.md                    # Manual rápido de GitHub con enlaces al sitio web
```

---

## Invariantes de Documentación

1. **Principio de Documentación Pura:**
   - La carpeta `docs/` contiene **exclusivamente archivos Markdown puros** sin dependencias de frameworks ni bloat.
   - La configuración vive fuera, en `.vitepress/config.mjs` con `srcDir: "docs"`.

2. **Sincronización Multilateral:**
   - Si se añade un atajo o comando nuevo:
     1. Actualizar la guía específica en `docs/<tema>.md`.
     2. Actualizar la tabla maestra en `docs/cheatsheet.md`.
     3. Actualizar la sección de referencia rápida en `README.md`.
     4. Si es una nueva página `.md`, registrarla en `nav` y `sidebar` de `.vitepress/config.mjs`.

3. **Neutralidad de Ejemplos en IA (`docs/ai.md`):**
   - Los ejemplos conceptuales de SDD, Skills, Memoria y Plan Mode deben ser casos generales de software (ej: APIs REST, OAuth2, Rate Limiting), evitando referenciar la propia CLI de `omc` para evitar confusiones.

---

## Protocolo de Verificación y Build

1. **Verificar Enlaces y Formato:**
   - Comprobar que todas las rutas relativas (`./neovim.md`, `/instalacion`) sean válidas.
2. **Compilación Local con VitePress:**
   - Ejecutar la compilación de prueba:
     ```bash
     npm i -D vitepress && npx vitepress build && rm -rf node_modules package.json package-lock.json .vitepress/dist .vitepress/cache
     ```
3. **Criterio de Aprobación:**
   - `build complete in X.XXs` con 0 errores de Rollup y 0 enlaces rotos.
