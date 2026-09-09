---
title: "Ecosistema AI & Coding Agents (Pi)"
description: "Agente Pi en terminal, instalación mínima y extensiones opcionales para OhMyConfig."
---

OhMyConfig usa **Pi** como agente de IA principal en terminal. El flujo base del proyecto debe ser mínimo: instalar el binario `pi`, abrir una sesión y añadir extensiones sólo cuando una workflow las necesite.

---

## 1. Instalación base

```bash
./omc dev install
```

Este comando instala únicamente el CLI base:

```bash
npm install -g @earendil-works/pi-coding-agent
```

Después de instalarlo, inicia una sesión con:

```bash
pi
```

Para revisar los paquetes de Pi presentes en tu entorno:

```bash
pi list
```

> OhMyConfig ya no instala todo el catálogo LazyPi por defecto. Las extensiones se tratan como herramientas opcionales para mantener el setup liviano y evitar dependencias que no uses.

---

## 2. Paquetes opcionales detectados con `pi list`

La siguiente lista refleja los paquetes presentes actualmente en este entorno. Podés reinstalarlos o añadirlos en otra máquina con `pi install <paquete>` sólo cuando los necesites.

| Paquete | Comando de instalación | Para qué sirve |
| :--- | :--- | :--- |
| `npm:@juanibiapina/pi-extension-settings` | `pi install npm:@juanibiapina/pi-extension-settings` | Ajustes adicionales para la sesión de Pi. |
| `npm:pi-antigravity` | `pi install npm:pi-antigravity` | Generación de imágenes vía Antigravity/Gemini desde Pi. |
| `npm:pi-subagents` | `pi install npm:pi-subagents` | Delegación a subagentes, workflows paralelos y worktrees aislados. |
| `npm:pi-ask-user` | `pi install npm:pi-ask-user` | Preguntas bloqueantes con UI interactiva para decisiones ambiguas o riesgosas. |
| `npm:pi-slopchop` | `pi install npm:pi-slopchop` | Revisión/limpieza de prosa para evitar texto genérico o artificial. |
| `npm:@juanibiapina/pi-powerbar` | `pi install npm:@juanibiapina/pi-powerbar` | Barra/telemetría visual para la interfaz de Pi. |
| `npm:@narumitw/pi-lsp` | `pi install npm:@narumitw/pi-lsp` | Diagnósticos y arreglos mediante Language Server Protocol. |
| `npm:pi-smart-compact` | `pi install npm:pi-smart-compact` | Compactación inteligente del contexto en sesiones largas. |
| `npm:@bramburn/pi-model-council` | `pi install npm:@bramburn/pi-model-council` | Consulta a varios modelos para segunda opinión o decisiones técnicas. |
| `npm:pi-skill-dollar` | `pi install npm:pi-skill-dollar` | Invocación de skills con sintaxis `$skill-name`. |
| `npm:@ff-labs/pi-fff` | `pi install npm:@ff-labs/pi-fff` | Búsqueda rápida de archivos y contenido con `fffind`/`ffgrep`. |
| `npm:pi-hermes-memory` | `pi install npm:pi-hermes-memory` | Memoria persistente, búsqueda de sesiones y skills procedurales. |
| `npm:pi-web-access` | `pi install npm:pi-web-access` | Búsqueda web, verificación de fuentes y extracción de contenido. |
| `git:github.com/EveryInc/compound-engineering-plugin` | `pi install git:github.com/EveryInc/compound-engineering-plugin` | Suite Compound Engineering: planificación, review, PRs, handoffs y aprendizajes. |

---

## 3. Uso recomendado por necesidad

### Mínimo diario

```bash
pi
```

Usalo para editar código, ejecutar comandos, revisar archivos y trabajar en el repo.

### Cuando necesitás subagentes o reviews paralelas

```bash
pi install npm:pi-subagents
```

Útil para code review, análisis en paralelo o workflows con worktrees.

### Cuando querés confirmaciones interactivas

```bash
pi install npm:pi-ask-user
```

Útil para que el agente pida confirmación antes de cambios ambiguos, destructivos o de arquitectura.

### Cuando necesitás LSP

```bash
pi install npm:@narumitw/pi-lsp
```

Útil para diagnósticos de TypeScript, Lua, Go, Rust, Python u otros servidores configurados.

### Cuando necesitás memoria y continuidad

```bash
pi install npm:pi-hermes-memory
```

Útil para recordar preferencias, decisiones de proyecto y procedimientos reutilizables entre sesiones.

### Cuando necesitás búsqueda web

```bash
pi install npm:pi-web-access
```

Útil para documentación actualizada, verificación de claims y lectura de URLs.

### Cuando querés workflows Compound Engineering

```bash
pi install git:github.com/EveryInc/compound-engineering-plugin
```

Habilita skills como `ce-plan`, `ce-work`, `ce-code-review`, `ce-commit-push-pr`, `ce-handoff` y `ce-setup`.

---

## 4. Comandos de mantenimiento

```bash
./omc dev status    # Ver versión de Pi y paquetes actuales con pi list
./omc dev update    # Actualizar el CLI base de Pi
./omc dev doctor    # Diagnóstico básico: Node/npm, Pi y paquetes instalados
./omc dev remove    # Mostrar ayuda para desinstalar paquetes con pi remove
```

Para actualizar o administrar extensiones opcionales, usa los comandos nativos de Pi según corresponda:

```bash
pi list
pi install <paquete>
pi remove <paquete>
```

---

## 5. Configuración visual project-local

OhMyConfig incluye configuración local de Pi declarada en `.pi/settings.json` y almacenada bajo `config/pi/`:

| Archivo | Rol |
| :--- | :--- |
| `.pi/settings.json` | Selecciona el theme `ohmyconfig-static-noise` y carga recursos locales con rutas relativas a `.pi/` (`../config/pi/...`). |
| `config/pi/themes/ohmyconfig-static-noise.json` | Theme Static Noise para la TUI de Pi. Usa la misma paleta del repo: superficies neutrales oscuras `#141720`, texto `#E6E2D6`, foco cian `#72EAD5` y acentos semánticos. |
| `config/pi/extensions/ohmyconfig-header.ts` | Reemplaza el header inicial de Pi y agrega una mini-barra persistente encima del editor con el símbolo `π`. |

Para que Pi cargue estos recursos locales, confiá el proyecto una vez desde una sesión interactiva:

```bash
pi
/trust
/reload
```

También podés probarlo una vez sin guardar confianza persistente:

```bash
pi --approve
```

---

## 6. Principio operativo

Instala primero **Pi base**. Luego añade sólo las extensiones que respondan a una necesidad real del flujo de trabajo. Esto reduce fricción, dependencias globales y ruido al depurar el entorno.
