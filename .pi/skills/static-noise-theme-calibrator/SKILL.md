---
name: static-noise-theme-calibrator
description: "Trigger: tema, color, estilo, paleta, static noise, calibrar colores, theme. Audita y aplica la paleta Static Noise con alto contraste en cualquier configuración del repositorio."
---

# Static Noise Theme Calibrator Skill

Esta skill audita, calibra y aplica la paleta canónica **Static Noise** en cualquier configuración de herramienta del ecosistema OhMyConfig.

---

## Tabla Canónica de Colores (Static Noise)

| Token | Hex | Rol Semántico |
|---|---|---|
| `void` | `#0F1117` | Fondo más profundo, barras de estado y chrome |
| `base` | `#141720` | Fondo principal neutral (terminal y editor) |
| `raised` | `#1B1F2A` | Paneles, popups y menús |
| `overlay` | `#202532` | Ventanas flotantes |
| `selection` | `#252A38` | Fondo de selección inactiva |
| `border` | `#343A4A` | Bordes inactivos y separadores |
| `borderFocus` | `#72EAD5` | Borde del panel activo y foco |
| `text` | `#E6E2D6` | Texto principal cálido |
| `textSoft` | `#C9C8C2` | Texto secundario |
| `muted` | `#9299AE` | Comentarios y metadatos |
| `disabled` | `#62697B` | Elementos desactivados y números de línea |
| `cyan` | `#72EAD5` | Foco activo, cursor y operador |
| `blue` | `#83BFFF` | Funciones, identificadores y enlaces |
| `purple` | `#C2A7FF` | Tipos, clases y ramas Git |
| `pink` | `#F08BC2` | Keywords de control |
| `green` | `#A3D98B` | Éxito, strings y adiciones Git |
| `yellow` | `#EDD071` | Advertencia, atención y atributos |
| `orange` | `#F3A261` | Números, modificaciones Git y duración |
| `red` | `#EF7785` | Error, peligro y eliminaciones Git |
| `cyanDim` | `#193C3B` | Fondo de selección activa |
| `greenDim` | `#293B2C` | Fondo de adición en diffs |
| `orangeDim` | `#493124` | Fondo de modificaciones en diffs |
| `redDim` | `#48262E` | Fondo de eliminaciones en diffs |

---

## Procedimiento de Calibración

1. **Identificar la herramienta** y su archivo de configuración bajo `config/<tool>/`.
2. **Consultar `documentation/colores.md`** como fuente canónica de tokens y reglas semánticas.
3. **Mapear sintaxis:**
   - Fish: hexadecimales sin prefijo `#` (ej. `72EAD5`).
   - FZF, TOML, YAML, KDL, Lua, CSS, Git: códigos hexadecimales completos con `#` (ej. `#72EAD5`).
4. **Verificar foco:** El elemento enfocado siempre usa `cyan` (`#72EAD5`).
5. **Verificar selección y diffs:** Los fondos usan variantes `Dim` o `selection`, nunca acentos brillantes sobre áreas extensas.
