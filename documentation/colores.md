---
title: "Paleta Static Noise"
description: "Especificación completa de tokens, roles y colores canónicos de Static Noise."
---

Armé el tema visual **Static Noise** porque estaba cansado de tener un entorno donde cada herramienta usaba una paleta distinta: el editor con un tema, la terminal con otro y las utilidades CLI con colores estándar que chocaban entre sí.

Static Noise es el **sistema cromático y tema visual oficial** de OhMyConfig. Diseñado específicamente para programar muchas horas sin fatiga visual en macOS: fondos abisales neutrales (`#0B0D13` y `#11141D`), texto nítido en marfil frío (`#EDEDEA`) y acentos eléctricos de alto contraste en Cyan (`#72EAD5`), Azul (`#83BFFF`) y Púrpura (`#C2A7FF`).

---

## 1. Tokens canónicos

### Superficies, texto y estructura

| Token | Hex | Rol y uso previsto |
|---|---:|---|
| `void` | `#0F1117` | Fondo más profundo, barras de estado y chrome exterior |
| `base` | `#141720` | Fondo principal neutral para terminal, editor y ventanas |
| `raised` | `#1B1F2A` | Paneles secundarios, popups, menús y cajas flotantes |
| `overlay` | `#202532` | Ventanas flotantes modales y elementos elevados |
| `selection` | `#252A38` | Fondo de selección inactiva, búsqueda y línea activa |
| `border` | `#343A4A` | Bordes inactivos, divisores y separadores tenues |
| `borderFocus` | `#72EAD5` | Borde del panel activo, cursor y foco dominante |
| `text` | `#E6E2D6` | Texto principal cálido (papel marfil frío) |
| `textSoft` | `#C9C8C2` | Texto secundario de lectura continua |
| `muted` | `#9299AE` | Comentarios, metadatos y estado secundario |
| `disabled` | `#62697B` | Elementos desactivados y números de línea inactivos |

### Señales cromáticas semánticas

| Token | Hex | Rol y significado global |
|---|---:|---|
| `cyan` | `#72EAD5` | Foco activo, cursor, operador destacado y marca principal |
| `blue` | `#83BFFF` | Funciones, identificadores, enlaces de navegación e información |
| `purple` | `#C2A7FF` | Tipos, clases, módulos y ramas de Git |
| `pink` | `#F08BC2` | Keywords de control, sentencias y comandos especiales |
| `green` | `#A3D98B` | Éxito, strings, adiciones Git y estado saludable |
| `yellow` | `#EDD071` | Advertencia, atención, atributos, duración y espera |
| `orange` | `#F3A261` | Números, modificaciones Git, constantes y actividad |
| `red` | `#EF7785` | Error, peligro, eliminaciones Git y roturas críticas |

### Acentos atenuados para fondos (`Dim`)

Se utilizan exclusivamente como fondos para selecciones, badges, diffs o alertas en bloque. **Nunca deben usarse como color de texto principal ni reemplazar superficies completas.**

| Token | Hex | Rol derivado |
|---|---:|---|
| `cyanDim` | `#193C3B` | Fondo de selección activa o foco persistente |
| `blueDim` | `#20344D` | Fondo de bloque informativo o documentación |
| `purpleDim` | `#332B4D` | Fondo de hunk headers y metadatos estructurales |
| `pinkDim` | `#48283D` | Fondo especial para etiquetas de control |
| `greenDim` | `#293B2C` | Fondo de adición en diffs y alertas de éxito |
| `yellowDim` | `#443B25` | Fondo de alertas preventivas y matches de búsqueda |
| `orangeDim` | `#493124` | Fondo de modificaciones en diffs |
| `redDim` | `#48262E` | Fondo de eliminaciones en diffs y alertas de error |

---

## 2. Reglas del sistema y jerarquía visual

1. **Predominancia neutral:** `base` ocupa la mayor parte de la superficie visible. `void` se reserva para barras y contraste de profundidad. Los acentos saturados no deben cubrir áreas de fondo extensas.
2. **Foco semántico único:** `cyan` (`#72EAD5`) identifica siempre el elemento o panel con foco actual activo. No debe usarse como adorno estético arbitrario.
3. **Estructura vs Estado:**
   - `blue`, `purple` y `pink` representan estructura y sintaxis (funciones, tipos, palabras clave).
   - `green`, `yellow`, `orange` y `red` representan exclusivamente estado y cambio temporal.
4. **Límites de resplandor (glow):** El texto normal no lleva efectos de resplandor. Solo se permite un halo sutil en el cursor activo, el indicador de foco o la identidad `π`.
5. **Tipografía auxiliar:**
   - Texto principal: `text` (`#E6E2D6`).
   - Comentarios y notas secundarias: `muted` (`#9299AE`).
   - Controles no disponibles o números de línea: `disabled` (`#62697B`).
   - Cursivas permitidas: keywords, llamadas a funciones, comentarios y modificadores; nunca en strings, números ni texto plano de interfaces.

---

## 3. Jerarquía de estados combinados

Cuando varios estados coinciden sobre el mismo elemento visual, se aplica la siguiente precedencia:

1. **Foco activo vs Selección inactiva:**
   - **Elemento enfocado y activo:** Cursor/borde cian brillante (`cyan`) con texto marfil iluminado (`text`) sobre fondo `cyanDim`.
   - **Elemento seleccionado pero sin foco:** Fondo atenuado neutro (`selection`), borde neutro (`border`) y texto `textSoft`.
2. **Estados críticos + Selección:**
   - Si un elemento con error o advertencia es seleccionado, **el color semántico de la alerta (`red` o `yellow`) permanece intacto en el texto o símbolo/icono**. La selección se aplica exclusivamente al fondo (`selection` o `redDim`), asegurando que la alerta crítica jamás sea enmascarada por el color de selección.
3. **Elementos deshabilitados + Selección:**
   - Mantienen el texto en `disabled` (`#62697B`) con fondo `selection` atenuado.

---

## 4. Accesibilidad y contraste

Static Noise está calibrado para superar los criterios WCAG 2.1 AA en interfaces oscuras:

- **Texto normal:** `text` (`#E6E2D6`) sobre `base` (`#141720`) provee un ratio de contraste superior a **11:1** (superando el mínimo de 4.5:1).
- **Texto auxiliar:** `muted` (`#9299AE`) sobre `base` provee un ratio superior a **5.2:1**.
- **Indicadores de foco:** `cyan` (`#72EAD5`) sobre fondos oscuros proporciona más de **9.5:1** de contraste frente a elementos inactivos (`border`).
- **Redundancia no cromática:** Todo estado crítico debe acompañarse de un símbolo o etiqueta de texto inequívoca (`✓`, `▲`, `✕`, `●`, `[ERROR]`, `[WARN]`), garantizando que la legibilidad no dependa únicamente de la percepción del color.

---

## 5. Variables portables

Para integraciones web (Astro, Starlight, CSS) o herramientas compatibles con variables de diseño:

```css
:root {
  /* Superficies */
  --sn-void: #0F1117;
  --sn-base: #141720;
  --sn-raised: #1B1F2A;
  --sn-overlay: #202532;
  --sn-selection: #252A38;
  --sn-border: #343A4A;
  --sn-border-focus: #72EAD5;

  /* Tipografía */
  --sn-text: #E6E2D6;
  --sn-text-soft: #C9C8C2;
  --sn-muted: #9299AE;
  --sn-disabled: #62697B;

  /* Señales cromáticas */
  --sn-cyan: #72EAD5;
  --sn-blue: #83BFFF;
  --sn-purple: #C2A7FF;
  --sn-pink: #F08BC2;
  --sn-green: #A3D98B;
  --sn-yellow: #EDD071;
  --sn-orange: #F3A261;
  --sn-red: #EF7785;

  /* Acentos atenuados (Dim) */
  --sn-cyan-dim: #193C3B;
  --sn-blue-dim: #20344D;
  --sn-purple-dim: #332B4D;
  --sn-pink-dim: #48283D;
  --sn-green-dim: #293B2C;
  --sn-yellow-dim: #443B25;
  --sn-orange-dim: #493124;
  --sn-red-dim: #48262E;
}
```
