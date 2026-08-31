---
name: tokyonight-theme-calibrator
description: "Trigger: tema, color, estilo, paleta, tokyonight, calibrar colores, theme. Audita y aplica la paleta Tokyonight Night con alto contraste en cualquier configuración del repositorio."
---

# Tokyonight Theme Calibrator Skill

Esta skill define la tabla de colores canónica y las reglas de diseño visual para mantener coherencia estética absoluta en todas las herramientas de **OhMyConfig**.

---

## Tabla Canónica de Colores (Tokyonight Night)

| Rol Semántico | Código HEX | Nombre / Uso |
| :--- | :--- | :--- |
| **Fondo Principal** | `#1a1b26` | Background estándar (Ghostty, Neovim, Zellij, Bottom). |
| **Fondo Profundo / Marcos** | `#15161e` / `#292e42` | Bordes inactivos, fondos secundarios o barras tenues. |
| **Texto Principal (Foreground)**| `#c0caf5` | Texto plano, código base, títulos normales. |
| **Texto Secundario / Comentarios**| `#565f89` / `#7a88cf`| Comentarios, líneas mudas, descripciones tenues. |
| **Foco Activo (Cyan Neón)** | `#7dcfff` / `#50f5ff` | Panel enfocado (Cyan brillante), comandos CLI, links. |
| **Cabeceras y Títulos (Azul)** | `#7aa2f7` | Título de panel activo, ramas de git, badges primarios. |
| **Éxito y Añadidos (Verde)** | `#9ece6a` | Tests pasando, líneas agregadas en diffs, status OK. |
| **Púrpura / Acento Secundario**| `#bb9af7` / `#c099ff`| Pestañas activas, palabras clave, subcomandos. |
| **Advertencia / Atención (Amarillo)**| `#e0af68` | Warnings, commits pendientes, flags. |
| **Naranja / Runtime** | `#ff9e64` | Lenguajes en prompt (mise), números, constantes. |
| **Peligro / Eliminados (Rojo)** | `#f7768e` | Errores, líneas borradas en diffs, fallos de test. |

---

## Invariantes de Diseño

1. **Alto Contraste de Foco en Paneles (Zellij):**
   - El panel enfocado **siempre** debe iluminarse en **Cyan (`#7dcfff`)** con barra en **Azul (`#7aa2f7`)**.
   - Los paneles inactivos permanecen en un tono gris oscuro tenue (`#292e42`).

2. **Transparencia y Desenfoque:**
   - En Neovim (`colorscheme.lua`) y Ghostty (`config`), el fondo debe permitir desenfoque (*blur*) sin fondos opacos negros puros (`#000000`).

3. **Diffs en Git-Delta y Lazygit:**
   - Líneas agregadas: Fondo `#1c333b`, énfasis `#2e5c54`, número de línea `#9ece6a`.
   - Líneas borradas: Fondo `#3b222c`, énfasis `#702d3d`, número de línea `#f7768e`.

---

## Protocolo de Calibración

1. **Inspección:** Leer el archivo de configuración a calibrar (`.kdl`, `.lua`, `.toml`, `.yml`, `.sh`).
2. **Auditoría de Colores:** Identificar cualquier código HEX que no pertenezca a la paleta o que cree bajo contraste.
3. **Reemplazo Semántico:** Aplicar los valores de la tabla canónica según el rol del elemento.
4. **Verificación Visual:** Comprobar legibilidad y consistencia con las demás herramientas del stack.
