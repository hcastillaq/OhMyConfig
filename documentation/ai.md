---
title: "Ecosistema AI & Coding Agents (Pi)"
description: "Agente Pi en terminal, instalación base mínima y extensiones recomendadas para OhMyConfig."
---

En OhMyConfig uso **Pi** (`@earendil-works/pi-coding-agent`) como agente principal de inteligencia artificial en la terminal. 

La filosofía acá es la misma que con el resto del setup: **cero bloat**. No me gusta que un instalador me meta 30 extensiones que no pedí y que solo agregan lentitud y consumo de memoria. Por eso, el flujo parte de una instalación base mínima y liviana, y vas incorporando paquetes según lo que tu día a día te pida.

---

## 1. Instalación base

Instalás el CLI base directamente con nuestro gestor:

```bash
./omc dev install
```

Por debajo, este comando instala únicamente el paquete oficial:

```bash
npm install -g @earendil-works/pi-coding-agent
```

Una vez instalado, podés abrir una sesión interactiva en cualquier carpeta con:

```bash
pi
```

Y para consultar qué extensiones tenés activas en ese momento:

```bash
pi list
```

---

## 2. Extensiones recomendadas para potenciar tu workflow

Estas son las extensiones que uso y recomiendo para transformar a Pi en un verdadero compañero de desarrollo en proyectos reales. Podés instalar cualquiera de ellas en cualquier momento con `pi install <paquete>`:

### Agentes, delegación y revisión de código

| Extensión | Instalación | Por qué la recomiendo |
| :--- | :--- | :--- |
| **`pi-subagents`** | `pi install npm:pi-subagents` | Permite a Pi delegar tareas a subagentes en paralelo, ejecutar code reviews estructuradas y aislar cambios en worktrees temporales de Git. Fundamental para tareas complejas. |
| **`pi-model-policy`** | Incluida en `config/pi/extensions/` | Enrutador inteligente para subagentes. Asigna automáticamente el modelo y nivel de *thinking* óptimo según la tarea (FAST, RESEARCH, BUILD, REASON, ARCHITECT, ORACLE), desempatando por menor costo por token y protegiendo cuotas sin escalado ascendente. |
| **`pi-ask-user`** | `pi install npm:pi-ask-user` | Interfaz interactiva de preguntas. Hace que el agente te consulte opciones antes de tomar decisiones arquitectónicas o ejecutar cambios destructivos. |
| **`pi-model-council`** | `pi install npm:@bramburn/pi-model-council` | Consulta a varios modelos en paralelo (Claude, GPT, Gemini) cuando necesitás una segunda opinión sobre un refactor o un bug elusivo. |
| **`compound-engineering-plugin`** | `pi install git:github.com/EveryInc/compound-engineering-plugin` | Suite de ingeniería continua: planificación de features (`ce-plan`), ejecución guiada (`ce-work`), reviews y handoffs entre sesiones. |

### Memoria, contexto y búsqueda

| Extensión | Instalación | Por qué la recomiendo |
| :--- | :--- | :--- |
| **`pi-hermes-memory`** | `pi install npm:pi-hermes-memory` | Memoria persistente entre sesiones. Recuerda decisiones previas del proyecto, tus convenciones de código y procedimientos que no querés tener que repetirle. |
| **`pi-smart-compact`** | `pi install npm:pi-smart-compact` | Compactación inteligente del historial de conversación. Mantiene el contexto relevante en sesiones largas sin saturar la ventana de tokens. |
| **`pi-web-access`** | `pi install npm:pi-web-access` | Búsqueda web y extracción de contenido en tiempo real. Ideal para consultar documentación de librerías recién salidas o verificar APIs. |
| **`pi-fff`** | `pi install npm:@ff-labs/pi-fff` | Búsqueda ultrarrápida de archivos y contenido en repositorios grandes usando `fffind` y `ffgrep`. |

### Herramientas de desarrollo y lenguaje

| Extensión | Instalación | Por qué la recomiendo |
| :--- | :--- | :--- |
| **`pi-lsp`** | `pi install npm:@narumitw/pi-lsp` | Conecta a Pi con tus Language Servers locales (TypeScript, Rust, Go, Python) para diagnósticos precisos y correcciones automáticas de sintaxis. |
| **`pi-extension-settings`** | `pi install npm:@juanibiapina/pi-extension-settings` | Panel interactivo para configurar variables y opciones de tus extensiones sin tener que editar JSONs a mano. |
| **`pi-powerbar`** | `pi install npm:@juanibiapina/pi-powerbar` | Barra de telemetría visual inferior para ver tokens, modelo activo y estado del agente de un vistazo. |
| **`pi-antigravity`** | `pi install npm:pi-antigravity` | Generación de diagramas y prototipos visuales directamente desde la conversación con Gemini/Antigravity. |

---

## 3. Mi receta según el tipo de trabajo

* **Para el día a día (editar, buscar, tests):** Solo el comando base `pi`. Rápido, enfocado y sin distracciones.
* **Para proyectos en equipo o refactors grandes:** Sumo `pi-subagents` y `pi-ask-user` para que revise código en paralelo y me pida confirmación antes de tocar archivos críticos.
* **Para tareas complejas de varios días:** Agrego `pi-hermes-memory` y `compound-engineering-plugin` para que el contexto y las decisiones arquitectónicas sobrevivan entre sesiones.

---

## 4. Estilo visual: tema Static Noise en Pi

Para que la ventana de Pi no desentone con Ghostty y Neovim, OhMyConfig incluye un tema visual propio almacenado en `config/pi/`:

* **`config/pi/themes/ohmyconfig-static-noise.json`:** Aplica los colores oficiales de Static Noise (fondos abisales `#141720`, texto marfil `#E6E2D6`, cursor y foco en Cyan `#72EAD5`).
* **`config/pi/extensions/ohmyconfig-header.ts`:** Sustituye el encabezado genérico por una barra limpia con el símbolo `π` y metadatos sutiles.
* **`config/pi/extensions/model-policy.ts`:** Enrutador dinámico de modelos para subagentes. Intercepta llamadas en vuelo y asigna automáticamente el modelo más económico y adecuado para cada tarea, con comandos `/model-policy status` y `/model-policy explain <agente>`.

Para activar este tema en tu entorno, abrí una sesión de Pi en este repositorio y confirmá los recursos locales:

```bash
pi
/trust
/reload
```

Si solo querés probarlo temporalmente sin guardar la confianza:

```bash
pi --approve
```

---

## 5. Comandos de mantenimiento rápido con `omc`

Desde la raíz del proyecto podés chequear y actualizar la base de Pi con:

```bash
./omc dev status    # Revisa la versión del binario y qué extensiones tenés instaladas
./omc dev update    # Actualiza el paquete global @earendil-works/pi-coding-agent
./omc dev doctor    # Verifica que Node, npm y el entorno de Pi estén en orden
```

Y para desinstalar o limpiar extensiones que ya no uses:

```bash
pi remove <nombre-de-extension>
```
