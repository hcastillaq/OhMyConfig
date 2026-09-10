---
title: Astro Starlight Cosmic Documentation - Plan
type: feat
date: 2026-09-09
topic: astro-starlight-cosmic-docs
artifact_contract: ce-unified-plan/v1
artifact_readiness: implementation-ready
product_contract_source: ce-brainstorm
execution: code
---

# Astro Starlight Cosmic Documentation - Plan

## Goal Capsule

- Objective: Proveer una plataforma web de documentación moderna, rápida e inmersiva para OhMyConfig que sustituya a VitePress, proyectando una atmósfera cósmica implícita calibrada bajo la paleta Static Noise y preservando la pureza de los archivos Markdown sin fricción en el despliegue.
- Means: Migración a Astro con el framework Starlight, inyectando personalizaciones visuales de espacio profundo en componentes de marco, integración de Expressive Code y búsqueda estática con Pagefind (KTD1, KTD2).
- Product Authority: ce-brainstorm
- Product Contract Preservation: Product Contract unchanged.
- Execution Profile: Código estático en Astro / Starlight sin runtime de servidor en producción; compilación local y en CI a `dist/`.
- Stop Conditions: El sitio compila limpiamente con `npm run build`, genera el índice de Pagefind sin errores de rutas y renderiza la atmósfera cósmica a 60 fps con soporte para `prefers-reduced-motion`.
- Open Blockers: Ninguno

---

## Product Contract

### Summary

Reemplazar el sitio de documentación actual basado en VitePress por una implementación moderna con Astro y Starlight. La nueva web ofrece una experiencia de lectura flat y limpia para desarrolladores, con un fondo de atmósfera cósmica implícita (luz difusa al 8.5%, partículas estelares al 100% y grano analógico al 1.5%), bloques de código con resaltado sintáctico de alto contraste y búsqueda instantánea fuera de línea.

### Problem Frame

La documentación actual de OhMyConfig utiliza VitePress con una personalización CSS básica que resulta excesivamente plana y genérica. Los estilos rígidos del tema por defecto dificultan crear una identidad visual inmersiva orientada a desarrolladores de terminal. Además, se requiere una estética que evoque el vacío cósmico y la textura de Static Noise sin recurrir a clichés ni etiquetas textuales de ciencia ficción, manteniendo intacta la velocidad y el principio de documentación pura en Markdown.

### Key Decisions

- KTD1. Migración de plataforma a Astro + Starlight (session-settled: user-directed — elegido frente a continuar en VitePress o desarrollar un sitio Astro desde cero: ofrece control total de componentes mediante overrides conservando la accesibilidad, el buscador Pagefind y el motor Expressive Code). Governs R1, R2, R4, R9.
- KTD2. Atmósfera cósmica puramente implícita (session-settled: user-directed — elegido frente a temáticas con terminología astronómica explícita: la inmersión espacial se transmite exclusivamente a través del diseño, la profundidad del vacío, halos de luz periféricos y partículas en microgravedad, descartando etiquetas textuales como coordenadas, órbitas o telemetría ficticia). Governs R3, R5, R6.
- KTD3. Calibración atmosférica fija (session-settled: user-directed — elegido frente a parámetros variables o presets genéricos: fijado en 8.5% de opacidad para halos lumínicos periféricos, 100% de densidad de partículas estelares sutiles a 60 fps y 1.5% de grano analógico Static Noise). Governs R5, R6.
- KTD4. Arquitectura de contenido desacoplada bajo el Principio de Documentación Pura (session-settled: user-approved — los archivos fuente en `documentation/` se conservan en Markdown estándar sin directivas propietarias de framework, cargados mediante el content loader de Astro). Governs R2, R8.

### Requirements

**Arquitectura y Compatibilidad de Contenido**

- R1. La web de documentación debe construirse con Astro v5 y el paquete oficial `@astrojs/starlight`.
- R2. El sitio debe consumir directamente los archivos Markdown existentes en la ruta repo-relativa `documentation/` sin exigir modificaciones de sintaxis propietaria ni mover las guías fuera de su ubicación estándar.
- R3. La navegación debe mantener la estructura jerárquica actual de OhMyConfig: Primeros Pasos (Instalación, AI & Agentes), Herramientas Centrales (Neovim, Zellij, Git, Terminal) y Referencia (Herramientas CLI, Cheatsheet, Colores).
- R4. La base URL debe configurarse como `/OhMyConfig/` para garantizar compatibilidad con GitHub Pages.

**Atmósfera Visual e Identidad de Diseño**

- R5. El marco de la página debe incorporar una capa de fondo cósmico persistente con los valores calibrados: halos periféricos difusos (cyan `#72EAD5`, azul `#83BFFF`, violeta `#C2A7FF` a 8.5% de opacidad), textura analógica de grano estático al 1.5% y un lienzo `<canvas>` con partículas en microgravedad al 100% de densidad operativa.
- R6. La animación de partículas debe ejecutarse de forma asíncrona mediante `requestAnimationFrame` garantizando 60 fps estables y consumo despreciable de CPU/GPU, pausándose si la pestaña pierde el foco o si el usuario tiene activado `prefers-reduced-motion`.
- R7. La interfaz debe seguir estrictamente la paleta Static Noise: fondos oscuros `#0B0D13` y `#11141D`, texto principal `#EDEDEA`, bordes sutiles de 1px semitransparentes y acentos cromáticos de alto contraste en elementos activos.

**Experiencia de Desarrollo y Rendimiento**

- R8. Las páginas de documentación deben servirse con cero JavaScript de cliente para el contenido de texto y navegación base, asegurando tiempos de carga inmediatos.
- R9. Los bloques de código deben utilizar Expressive Code con soporte para nombres de archivo, botones de copia rápida accesibles y resaltado sintáctico calibrado a la paleta de desarrollo.
- R10. El sitio debe contar con un buscador estático local y accesible provisto por Pagefind, indexando todo el contenido en tiempo de compilación.
- R11. El flujo de despliegue en `.github/workflows/docs.yml` debe actualizarse para compilar el proyecto con Astro y publicar la carpeta `dist/` resultante a GitHub Pages.

### Key Flows

- F1. Navegación y lectura técnica: El desarrollador accede a una guía desde el sidebar o el buscador Pagefind. La página carga de forma instantánea sin retrasos de hidratación. El fondo cósmico provee atmósfera sin interferir con la legibilidad del texto ni con el contraste de los bloques de código.
- F2. Flujo de compilación y CI/CD: El desarrollador ejecuta `npm run build` en local o envía un commit a `main`. GitHub Actions instala dependencias, compila el sitio con Astro, indexa con Pagefind y despliega el artefacto a GitHub Pages de forma desatendida.

### Acceptance Examples

- AE1. Cero etiquetas explícitas de ciencia ficción
  - **Given** un usuario navegando por cualquier página o componente de la documentación.
  - **When** se inspecciona la interfaz, títulos, badges, footers y metadatos visibles.
  - **Then** no debe existir ninguna etiqueta textual de astronomía literal (tales como "ORBITAL", "COORDINATES", "TELEMETRY", "RA/DEC"), expresándose la atmósfera espacial únicamente a través del color, la luz, el grano y el movimiento del lienzo.
  - **Covers R5, R7.**

- AE2. Preservación del Principio de Documentación Pura
  - **Given** los archivos fuente en `documentation/*.md`.
  - **When** se ejecuta la compilación de Astro Starlight.
  - **Then** todos los archivos Markdown se procesan limpiamente sin requerir frontmatter propietario incompatible con visores Markdown estándar de terminal o GitHub.
  - **Covers R2, R8.**

- AE3. Rendimiento y reducción de movimiento
  - **Given** un usuario con la preferencia del sistema operativo `prefers-reduced-motion: reduce` activada.
  - **When** carga la web de documentación.
  - **Then** las partículas cósmicas se renderizan estáticas o se suspende el loop de animación, conservando los colores y el contraste sin movimientos visuales.
  - **Covers R6.**

### Scope Boundaries

- Dentro de alcance:
  - Instalación y configuración de Astro v5 y `@astrojs/starlight`.
  - Configuración del cargador de contenido para la carpeta `documentation/`.
  - Desarrollo del componente de marco y lienzo cósmico con los parámetros calibrados (Luz 8.5%, Partículas 100%, Grano 1.5%).
  - Estilos globales en CSS con las variables de la paleta Static Noise.
  - Configuración de Expressive Code para bloques de terminal y código fuente.
  - Adaptación del workflow de CI/CD en `.github/workflows/docs.yml`.
  - Limpieza progresiva de la configuración legacy de VitePress.

- Fuera de alcance:
  - Modificaciones a los scripts del CLI del repositorio (`omc`, `cli/**`).
  - Rediseño o reescritura de los textos técnicos de las guías existentes.
  - Inclusión de librerías pesadas de interfaz (React, Vue) en el cliente.

### Success Criteria

- Rendimiento: Puntuación de 100 en Performance y Accesibilidad en Lighthouse para páginas de contenido.
- Compilación: `npm run build` genera el directorio `dist/` sin advertencias de rutas rotas ni errores de TypeScript/Astro.
- Despliegue: Publicación automática exitosa en GitHub Pages (`https://<user>.github.io/OhMyConfig/`).
- Búsqueda: Búsqueda modal instantánea con Pagefind funcionando sin conexión a servidores externos.
- Estética: Atmósfera inmersiva comprobable visualmente, con fondo oscuro dinámico y legibilidad de código óptima.

---

## Planning Contract

### High-Level Technical Design

```
OhMyConfig/
├── package.json                 # Dependencias: astro, @astrojs/starlight
├── astro.config.mjs             # Integración Starlight, base /OhMyConfig/, overrides
├── tsconfig.json                # Configuración TypeScript para Astro/Starlight
├── src/
│   ├── content.config.ts        # Content Layer cargando documentation/*.md con docsLoader()
│   ├── styles/
│   │   └── custom.css           # Mapeo de Static Noise a variables --sl-color-* y Expressive Code
│   └── components/
│       ├── CosmicAtmosphere.astro  # Canvas 60fps (Luz 8.5%, Partículas 100%, Grano 1.5%)
│       └── CosmicPageFrame.astro   # Override de Starlight PageFrame inyectando el fondo
├── documentation/               # Markdown puro existente (intacto)
└── .github/workflows/docs.yml   # Workflow CI/CD actualizado a astro build
```

El flujo técnico opera de la siguiente manera:
1. `astro.config.mjs` inicializa Starlight con `site: 'https://hcastillaq.github.io'` y `base: '/OhMyConfig/'`.
2. Se configura el override de `PageFrame` (`components: { PageFrame: './src/components/CosmicPageFrame.astro' }`).
3. En `CosmicPageFrame.astro`, se renderiza `<CosmicAtmosphere />` en una capa fija (`z-index: 0`) y se invoca el `Default` de Starlight (`z-index: 1`), logrando que todo el contenido flote sobre el cosmos sin alterar el DOM interno de Starlight.
4. `src/styles/custom.css` redefine las propiedades de Starlight para que los paneles laterales, barras de navegación y fondos usen las transparencias y tonos de Static Noise (`#0B0D13`, `#11141D`, `#181C26` con `backdrop-filter: blur`).
5. Los archivos de `documentation/*.md` son cargados por Starlight; se garantiza que cada archivo cuente con su encabezado o título reconocible.

### Key Technical Decisions (KTDs)

- KTD1. Configuración de dependencias en `package.json` raíz. (session-settled: user-directed — elegido para estandarizar el tooling del repo: `package.json` declara `astro` y `@astrojs/starlight` con scripts `dev`, `build` y `preview`). Governs R1, R11.
- KTD2. Enlace de contenido de documentación mediante symlink relativo `src/content/docs` -> `../../documentation`. (session-settled: user-approved — garantiza 100% de compatibilidad con Starlight sin requerir reestructuración de la carpeta `documentation/` del repositorio). Governs R2, R4.
- KTD3. Inyección atmosférica mediante override de `PageFrame` en lugar de inyecciones de script en el `<head>`. (session-settled: user-approved — encapsula el canvas y el grano en un componente `.astro` desacoplado, permitiendo pruebas y aislamiento limpio). Governs R5, R6.
- KTD4. Personalización de sintaxis con Expressive Code integrado en Starlight. (session-settled: user-approved — sustituye Shiki plano por bloques con cabecera de archivo, pestaña de comando y botones de copia rápida accesibles). Governs R9.
- KTD5. Transición limpia en `.github/workflows/docs.yml` de VitePress a Astro. (session-settled: user-directed — sustituye el paso `npx vitepress build` por `npm ci && npm run build`, subiendo `dist/` como artefacto de Pages). Governs R11.

### Assumptions

- Node.js v20+ o superior está disponible tanto en el entorno local (v26 detectado) como en el runner de GitHub Actions (`ubuntu-latest` con `actions/setup-node@v4`).
- Las URLs relativas entre páginas de documentación (`/instalacion`, `/neovim`, etc.) se mapean automáticamente por Starlight sin requerir extensiones `.html` explícitas.
- El repositorio mantiene la rama `feature/astro-starlight-docs` hasta la validación completa del pre-merge gate.

### Dependencies & Prerequisites

- Dependencias npm a instalar: `astro`, `@astrojs/starlight`, `typescript`, `@types/node`.
- Ninguna dependencia adicional pesada (sin React, Tailwind ni Vue en cliente).

---

## Implementation Units

### U1. Project Initialization & Starlight Integration

- Goal: Establecer el entorno de desarrollo Astro con Starlight, TypeScript y scripts estándar en el repositorio.
- Requirements: R1, R4.
- Files:
  - `package.json` (nuevo)
  - `astro.config.mjs` (nuevo)
  - `tsconfig.json` (nuevo)
  - `.gitignore` (actualizar para ignorar `dist/`, `.astro/`, `node_modules/`)
- Approach:
  - Crear `package.json` con scripts `"dev": "astro dev"`, `"build": "astro build"`, `"preview": "astro preview"`.
  - Instalar dependencias exactas con npm.
  - Configurar `astro.config.mjs` con `site`, `base: '/OhMyConfig/'` e integración `starlight()`.
  - Configurar `tsconfig.json` extendiendo `astro/tsconfigs/strict`.
- Test Scenarios:
  - `npm run dev -- --help` ejecuta sin errores de módulos faltantes.
  - `astro.config.mjs` valida sintácticamente con Node.js.
- Verification: `npx astro --version` reporta Astro v5+ instalado correctamente.

### U2. Content Collection & Documentation Mapping

- Goal: Conectar la carpeta `documentation/` con Starlight asegurando que todas las guías se rendericen con títulos y jerarquía de navegación exacta.
- Requirements: R2, R3, R8.
- Files:
  - `src/content.config.ts` (nuevo)
  - `src/content/docs` (symlink a `../../documentation`)
  - `astro.config.mjs` (definir sidebar jerárquico de Starlight)
  - `documentation/*.md` (asegurar títulos limpios de frontmatter o H1 normalizados)
- Approach:
  - Crear `src/content.config.ts` con `defineCollection` y `docsLoader()`.
  - Establecer el symlink `src/content/docs -> ../../documentation`.
  - Configurar `sidebar` en `astro.config.mjs` replicando los 3 grupos de OhMyConfig (Primeros Pasos, Herramientas Centrales, Referencia).
  - Normalizar el frontmatter `title` en las 9 guías de `documentation/` para evitar advertencias de Starlight y eliminar bytes corruptos de emojis.
- Test Scenarios:
  - `npm run build` carga las 9 guías sin errores de esquema.
  - Todas las rutas (`/instalacion`, `/ai`, `/neovim`, `/zellij`, `/git`, `/terminal`, `/herramientas`, `/colores`, `/cheatsheet`) existen en la salida generada.
- Verification: `npx astro check` pasa sin errores de tipado en las colecciones.

### U3. Static Noise Theme & Expressive Code Styling

- Goal: Implementar el sistema de diseño de Static Noise en Starlight con alto contraste, tipografía monoespaciada técnica y bloques de código de terminal.
- Requirements: R7, R9.
- Files:
  - `src/styles/custom.css` (nuevo)
  - `astro.config.mjs` (enlazar `customCss: ['./src/styles/custom.css']`)
- Approach:
  - Declarar las variables de color Static Noise en `:root` (`--sn-void: #0B0D13`, `--sn-base: #11141D`, `--sn-border: rgba(255,255,255,0.08)`, `--sn-cyan: #72EAD5`, etc.).
  - Mapear las variables `--sl-color-*` de Starlight hacia la paleta Static Noise con fondos semitransparentes y desenfoque.
  - Estilizar Expressive Code: pestañas de archivo en terminal (`#181C26`), marcos con bordes de 1px sutiles y botones de copiado accesibles.
  - Ajustar tipografía técnica en títulos, sidebar y tabla de contenidos (TOC).
- Test Scenarios:
  - El contraste entre el texto (`#EDEDEA`) y el fondo (`#0B0D13`) supera el ratio WCAG AAA (>7:1).
  - Los bloques de código muestran la barra de título con icono de terminal y sintaxis resaltada en cyan, azul y magenta.
- Verification: Inspección visual en navegador comprobando coherencia con Ghostty y Neovim.

### U4. Cosmic Atmosphere Canvas & PageFrame Override

- Goal: Inyectar el lienzo dinámico de partículas estelares y halos de luz calibrados detrás del contenido mediante el override de `PageFrame`.
- Requirements: R5, R6.
- Files:
  - `src/components/CosmicAtmosphere.astro` (nuevo)
  - `src/components/CosmicPageFrame.astro` (nuevo)
  - `astro.config.mjs` (añadir override `components: { PageFrame: './src/components/CosmicPageFrame.astro' }`)
- Approach:
  - Desarrollar `CosmicAtmosphere.astro` con:
    1. Capa fija de halos lumínicos difusos en las esquinas al **8.5% de opacidad**.
    2. Textura SVG de grano analógico Static Noise al **1.5% de opacidad**.
    3. Canvas con simulación de partículas en microgravedad al **100% de densidad**, ejecutado en `requestAnimationFrame`.
    4. Detector de `prefers-reduced-motion` que desactiva la animación continua para accesibilidad.
  - Desarrollar `CosmicPageFrame.astro` que envuelve el layout por defecto de Starlight colocando la atmósfera en el fondo.
- Test Scenarios:
  - El canvas renderiza a 60 fps estables sin sobrecargar la CPU.
  - Al cambiar la preferencia del sistema a movimiento reducido, las partículas permanecen estáticas.
  - El scroll de la página de documentación es completamente fluido y el texto permanece nítido.
- Verification: Profiling de rendimiento en navegador certificando 60 fps y 0 frames caídos durante el scroll.

### U5. CI/CD GitHub Actions Workflow & VitePress Deprecation

- Goal: Actualizar el flujo automatizado de GitHub Pages y retirar los artefactos legacy de VitePress.
- Requirements: R10, R11.
- Files:
  - `.github/workflows/docs.yml` (actualizar)
  - `.vitepress/` (deprecar / remover tras verificar paridad completa)
  - `README.md` (actualizar instrucciones de compilación local de docs)
- Approach:
  - Modificar `.github/workflows/docs.yml` para instalar dependencias con `npm ci`, ejecutar `npm run build` y subir `dist` como artefacto de Pages.
  - Verificar que Pagefind genera el índice de búsqueda estática en la compilación.
  - Retirar la carpeta `.vitepress/` una vez confirmado que Astro compila el 100% de las rutas.
- Test Scenarios:
  - La acción local de build completa con código de salida 0.
  - La carpeta `dist/` contiene `index.html`, todas las páginas y la carpeta `pagefind/`.
- Verification: Simulación de build en entorno limpio reproduciendo el pipeline de GitHub Actions.

---

## Verification Contract

1. **Compilación de Producción:**
   ```bash
   npm run build
   ```
   Debe generar el directorio `dist/` conteniendo `index.html`, todas las rutas de `documentation/` y los índices estáticos de `pagefind/` sin advertencias de rutas 404.

2. **Verificación de Búsqueda Pagefind:**
   Verificar que `dist/pagefind/pagefind.js` existe y que la búsqueda modal en local encuentra términos clave como `omc`, `zellij`, `ghostty` y `neovim`.

3. **Verificación de Accesibilidad y Rendimiento:**
   Verificar contraste de color con DevTools y validar que el canvas se pausa con `@media (prefers-reduced-motion: reduce)`.

4. **Pre-Merge Gate de OhMyConfig:**
   ```bash
   bash -n omc cli/lib/*.sh cli/commands/*.sh
   ./omc doctor
   ```

---

## Definition of Done

- [ ] Todas las unidades de implementación (U1 a U5) están completadas y verificadas.
- [ ] La compilación `npm run build` es 100% verde y determinista.
- [ ] La atmósfera cósmica reproduce exactamente los parámetros calibrados (Luz 8.5%, Partículas 100%, Grano 1.5%).
- [ ] No existen etiquetas explícitas de ciencia ficción ni terminología astronómica en el texto.
- [ ] Las 9 guías de `documentation/` se conservan en Markdown puro y accesible.
- [ ] El workflow de GitHub Actions en `.github/workflows/docs.yml` está adaptado a Astro.
- [ ] El pre-merge gate de OhMyConfig (`bash -n`, `omc doctor`) pasa limpiamente.
