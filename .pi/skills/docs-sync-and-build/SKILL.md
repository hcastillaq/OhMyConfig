---
name: docs-sync-and-build
description: "Trigger: actualizar docs, nueva guia, docs sync, astro build, sincronizar documentacion. Sincroniza guías, cheatsheets y valida la compilación con Astro Starlight."
---

# Docs Sync and Build Skill

Esta skill define el protocolo para mantener la documentación de **OhMyConfig** sincronizada, libre de enlaces rotos y validada antes de cualquier despliegue a **GitHub Pages**.

---

## Arquitectura de la Documentación

```text
documentation/               # Fuentes puras en Markdown
├── index.md                 # Landing page con hero y feature cards
├── instalacion.md           # Guía de la CLI omc y Brewfile
├── ai.md                    # Ecosistema de IA (Pi y extensiones opcionales)
├── neovim.md                # Guía del editor Neovim y LazyVim
├── zellij.md                # Multiplexor Zellij y modo Move
├── git.md                   # Flujo de Git, Lazygit y Delta
├── terminal.md              # Ghostty, Fish, Starship y Atuin
├── herramientas.md          # Catálogo completo de CLI/TUI
└── cheatsheet.md            # Tabla maestra consolidada de atajos

astro.config.mjs             # Configuración del sitio (Astro + Starlight, sidebar y tema Static Noise)
README.md                    # Manual rápido de GitHub con enlaces al sitio web
```

---

## Invariantes de Documentación

1. **Principio de Documentación Pura:**
   - La carpeta `documentation/` contiene **exclusivamente archivos Markdown puros** sin dependencias de frameworks ni bloat.
   - La configuración vive fuera, en `astro.config.mjs` consumiendo `documentation/`.

2. **Sincronización Multilateral:**
   - Si se añade un atajo o comando nuevo:
     1. Actualizar la guía específica en `documentation/<tema>.md`.
     2. Actualizar la tabla maestra en `documentation/cheatsheet.md`.
     3. Actualizar la sección de referencia rápida en `README.md`.
     4. Si es una nueva página `.md`, registrarla en el `sidebar` de `astro.config.mjs`.

3. **Neutralidad de Ejemplos en IA (`docs/ai.md`):**
   - Los ejemplos conceptuales de SDD, Skills, Memoria y Plan Mode deben ser casos generales de software (ej: APIs REST, OAuth2, Rate Limiting), evitando referenciar la propia CLI de `omc` para evitar confusiones.

---

## Protocolo de Verificación y Build

1. **Verificar Enlaces y Formato:**
   - Comprobar que todas las rutas relativas (`./neovim.md`, `/instalacion`) sean válidas.
2. **Compilación Local con Astro:**
   - Ejecutar la compilación de prueba:
     ```bash
     npm run build
     ```
3. **Criterio de Aprobación:**
   - Compilación completa con 0 errores y generación exitosa del índice Pagefind.
