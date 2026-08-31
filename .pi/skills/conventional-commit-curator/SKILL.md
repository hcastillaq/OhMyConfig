---
name: conventional-commit-curator
description: "Trigger: commit, generar commit, crear commit, git commit, commit message, conventional commit. Inspecciona el staging y redacta commits con formato Conventional Commits estructurado."
---

# Conventional Commit Curator Skill

Esta skill define el estándar obligatorio para la redacción de mensajes de commit en **OhMyConfig**, alineado con la historia y convenciones del repositorio.

---

## Estructura de Commit Estándar

```text
<tipo>(<scope opcional>): <descripción imperativa en minúsculas y en inglés>

- <Punto 1: qué cambió y por qué>
- <Punto 2: detalle técnico o archivos involucrados>
- <Punto 3: impacto o verificación realizada>
```

---

## Tipos y Scopes Permitidos

### Tipos:
* **`feat`**: Nueva funcionalidad, nuevo comando en `omc` o nuevo módulo en el catálogo.
* **`fix`**: Corrección de bugs en scripts, atajos mal documentados o fallos de sintaxis.
* **`refactor`**: Reestructuración de código sin cambiar el comportamiento externo (ej: migrar de Fish a Bash).
* **`docs`**: Cambios exclusivos en la documentación (`docs/`, `README.md`, `AGENTS.md`).
* **`style`**: Ajustes estéticos, colores Tokyonight o formato sin cambio funcional.
* **`chore`**: Tareas de mantenimiento, actualización de dependencias, limpieza o ajustes en `.gitignore`.
* **`test`**: Nuevos tests o validaciones de scripts.

### Scopes Comunes:
* `(cli)`: Cambios en `./omc` o en la suite `cli/lib/`, `cli/commands/`.
* `(nvim)`: Cambios en `config/nvim/`.
* `(zellij)`: Cambios en `config/zellij/` o `zjstatus.wasm`.
* `(lazygit)`: Cambios en `config/lazygit/`.
* `(fish)`: Cambios en `config/fish/`.
* `(docs)`: Cambios en VitePress o guías Markdown.
* `(deps)`: Actualización de paquetes o herramientas en `Brewfile`.

---

## Protocolo de Ejecución

1. **Inspección de Cambios:**
   - Ejecutar `git status -s` y `git diff --staged` (o `git diff` si no hay staging).
2. **Determinación del Tipo y Scope:**
   - Si se tocan múltiples áreas, usar el scope predominante o dejarlo sin scope si es transversal.
3. **Redacción del Título:**
   - Modo imperativo en inglés (ej: `add`, `fix`, `refactor`, `update`), sin punto final, máximo 72 caracteres.
4. **Redacción del Cuerpo:**
   - Dejar una línea en blanco tras el título.
   - Detallar con viñetas `- ` los puntos técnicos clave.
5. **Ejecución del Commit:**
   - Ejecutar `git add <archivos>` y `git commit -m "..."` en comandos directos separados.
