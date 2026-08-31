---
name: omc-module-workflow
description: "Trigger: nuevo módulo, nuevo modulo, crear módulo, crear modulo, add tool, omc module, agregar herramienta. Guía la creación y mantenimiento estandarizado de módulos en OhMyConfig."
---

# OMC Module Workflow Skill

Esta skill define el protocolo obligatorio para agregar, modificar o eliminar módulos y herramientas en **OhMyConfig**.

## Contexto y Requisitos de Integración

Todo módulo en OhMyConfig debe integrarse en **5 capas sin excepción**:

1. **Definición en Catálogo (`cli/lib/catalog.sh`):**
   - Registrar el ID del módulo en el array `OMC_MODULES=(... nuevo_modulo)`.
   - Implementar `get_module_label <mod>` con su nombre legible.
   - Implementar `get_module_desc <mod>` con un resumen corto de herramientas.
   - Implementar `get_module_tools <mod>` con el listado en formato `type:package[:binary]` (ej: `brew:ripgrep:rg`, `cask:ghostty:ghostty`, `npm:pkg:bin`).
   - Implementar `get_module_configs <mod>` con las rutas relativas dentro de `config/` si despliega archivos.

2. **Bundle de Homebrew (`Brewfile`):**
   - Añadir las fórmulas (`brew "..."`) o casks (`cask "..."`) correspondientes con comentarios organizadores.

3. **Archivos de Configuración (`config/<tool>/`):**
   - Si la herramienta requiere dotfiles, crearlos bajo `config/<tool>/` con la paleta Tokyonight.

4. **Cheatsheet en Terminal (`config/fish/functions/guia.fish`):**
   - Agregar la categoría o comandos correspondientes al switch de `guia <categoria>` y al listado general de atajos.

5. **Documentación Oficial (`docs/`):**
   - Añadir la herramienta a la tabla de `docs/instalacion.md` (sección Módulos Disponibles).
   - Documentar comandos y casos de uso en `docs/herramientas.md` o en la guía modular respectiva.
   - Actualizar `docs/cheatsheet.md` y `README.md`.

---

## Protocolo de Ejecución Paso a Paso

1. **Validación de Paquetes:**
   - Verificar si la fórmula o cask existe con `brew search <paquete>` o `npm view <paquete>`.
2. **Edición del Catálogo:**
   - Actualizar `cli/lib/catalog.sh` asegurando sintaxis compatible con Bash 3.2 (sin arrays asociativos).
3. **Actualización de Brewfile:**
   - Agregar el paquete en `Brewfile`.
4. **Despliegue y Cheatsheet:**
   - Si tiene configs, crearlas en `config/` y actualizar `config/fish/functions/guia.fish`.
5. **Verificación de Integridad:**
   - Ejecutar `bash -n omc cli/lib/*.sh cli/commands/*.sh` para asegurar que no haya errores de sintaxis.
   - Ejecutar `./omc doctor` y comprobar que reconozca el nuevo módulo y reporte el estado de los paquetes.
   - Ejecutar `npx vitepress build` para verificar que la documentación compila sin errores.

---

## Criterios de Aceptación

- `bash -n omc cli/lib/*.sh cli/commands/*.sh` pasa con código de salida 0.
- `./omc doctor` lista el nuevo módulo con sus herramientas asociadas.
- `npx vitepress build` compila limpiamente.
- No quedan archivos huérfanos ni dependencias no documentadas.
