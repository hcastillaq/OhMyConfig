# 🤖 Ecosistema AI & Coding Agents

OhMyConfig integra un stack de última generación para **desarrollo asistido por Inteligencia Artificial y agentes autónomos de código** directamente en la terminal. En lugar de depender de editores cerrados o interfaces web pesadas, el entorno combina agentes CLI ultra veloces, harness de desarrollo controlado (SDD) y memoria persistente local entre sesiones.

---

## 1. Arquitectura del Stack de AI

El ecosistema está compuesto por tres herramientas principales distribuidas como paquetes globales de Node (`npm`) y gestionadas automáticamente por `omc`:

```
┌─────────────────────────────────────────────────────────────┐
│                    Terminal (Ghostty / Zellij)              │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │               pi (Coding Agent Harness)             │   │
│   │   • TUI interactiva y CLI ultra veloz               │   │
│   │   • Lectura, edición, ejecución y búsqueda         │   │
│   └───────────────┬─────────────────────┬───────────────┘   │
│                   │                     │                   │
│   ┌───────────────▼──────────┐   ┌──────▼───────────────┐   │
│   │        gentle-pi         │   │    gentle-engram     │   │
│   │ • Spec-Driven Dev (SDD)  │   │ • Memoria semántica  │   │
│   │ • Catálogo de Skills     │   │   y episódica local  │   │
│   │ • Reviews y subagentes   │   │ • SQLite persistente │   │
│   └──────────────────────────┘   └──────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

| Componente | Paquete npm | Rol y Funcionalidad |
| :--- | :--- | :--- |
| **`pi`** | `@earendil-works/pi-coding-agent` | Agente de código en terminal para explorar repositorios, editar código, ejecutar pruebas y resolver tareas con modelos de lenguaje de vanguardia. |
| **`gentle-pi`** | `gentle-pi` | Extensión y harness para Pi que provee metodología **SDD / OpenSpec**, gestión de subagentes, revisiones de código estructuradas y un catálogo de skills especializadas. |
| **`gentle-engram`** | `gentle-engram` | Sistema de **memoria episódica persistente** para Pi impulsado por base de datos SQLite local. Permite al agente recordar decisiones de arquitectura, convenciones y soluciones entre sesiones. |

---

## 2. Gestión con la CLI `omc dev`

OhMyConfig incluye comandos dedicados dentro de `omc` para instalar, auditar y actualizar todo el ecosistema de AI en un solo paso:

### Instalación de Herramientas
```bash
./omc dev              # Instala pi + gentle-pi + gentle-engram
# o explícitamente:
./omc dev install
```

### Verificación de Estado y Versiones
Compara las versiones instaladas localmente contra las últimas publicadas en el registro de npm:
```bash
./omc dev status
```

### Actualización al Último Release
Actualiza automáticamente los tres paquetes a su versión `latest`:
```bash
./omc dev update
```

---

## 3. Activación de Extensiones en `pi`

Una vez instalados los paquetes globales, activá las extensiones dentro de tu entorno de Pi:

```bash
# 1. Instalar y activar el harness de Gentle AI (Skills + SDD)
pi install gentle-pi

# 2. Instalar y activar la memoria persistente de Gentle Engram
pi install gentle-engram
```

---

## 4. Flujo de Trabajo y Capacidades

### 4.1 Uso de `pi` en la Terminal
Iniciá el agente dentro de cualquier repositorio o directorio de trabajo:

```bash
pi
```

Podés solicitar refactorizaciones, creación de pruebas, investigación de errores, navegación de código o generación de características complejas con retroalimentación en tiempo real.

### 4.2 Spec-Driven Development (SDD / OpenSpec) con `gentle-pi`
`gentle-pi` introduce un flujo estructurado de desarrollo guiado por especificaciones:
- **Clarificación de Requerimientos:** Define alcance, criterios de aceptación y restricciones antes de escribir código.
- **Propuestas y Tareas:** Genera artefactos de fase (`proposal`, `spec`, `design`, `tasks`) para proyectos no triviales.
- **Orquestación de Subagentes:** Delega fases de exploración, implementación y verificación manteniendo el contexto limpio.
- **Transacciones de Revisión:** Validación estricta y revisión de cambios antes de realizar commits o pull requests.

### 4.3 Memoria Persistente con `gentle-engram`
Gracias a `gentle-engram`, el agente no olvida el contexto entre sesiones:
- **Decisiones de Arquitectura:** Registra elecciones de diseño y convenciones del repositorio.
- **Patrones y Preferencias:** Almacena cómo prefieres estructurar el código, estilos de nombrado o librerías favoritas.
- **Solución de Errores Complejos:** Recuerda problemas resueltos previamente para evitar repetir diagnósticos.

### 4.4 Catálogo de Skills Integradas
Con `gentle-pi`, tenés acceso a un conjunto de habilidades preconfiguradas:
- **`gentle-ai-branch-pr`**: Creación y preparación de Pull Requests estructurados.
- **`gentle-ai-chained-pr`**: División de cambios grandes en PRs secuenciales y revisables.
- **`cognitive-doc-design`**: Diseño de documentación técnica optimizada para reducir carga cognitiva.
- **`gentle-ai-judgment-day`**: Revisiones duales rigurosas previas a merge.
- **`gentle-ai-skill-creator`**: Creación de nuevas habilidades personalizadas para el agente.

---

## 5. Actualización Global con `omc update`

El comando de mantenimiento general de OhMyConfig incluye la actualización del stack de AI junto con Homebrew y los casks:

```bash
./omc update
```

Esto asegura que tanto tus herramientas del sistema (`fish`, `nvim`, `zellij`, `eza`, `ripgrep`) como tus herramientas de IA (`pi`, `gentle-pi`, `gentle-engram`) se mantengan siempre al día.
