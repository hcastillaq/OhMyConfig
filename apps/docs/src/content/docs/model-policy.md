---
title: Pi Model Policy
description: Enrutador inteligente y autónomo de modelos y niveles de razonamiento para subagentes en Pi.
---

**Pi Model Policy** es una extensión para Pi que selecciona automáticamente el modelo y el nivel de razonamiento (*thinking*) más apropiados para cada subagente según la tarea que va a realizar.

Su objetivo no es forzar siempre el modelo más potente, sino **asignar el modelo adecuado para cada trabajo**, equilibrando calidad técnica, velocidad y consumo eficiente de cuotas entre múltiples proveedores sin requerir configuraciones manuales complejas.

```text
Compound Engineering / SDD / Flujos Custom
                    │
                    │ 1. Despacha subagente (ej. ce-security-reviewer)
                    ▼
          ┌───────────────────┐
          │  pi.on(tool_call) │  ◄── Intercepción no invasiva en memoria
          └─────────┬─────────┘
                    │
                    ▼
          ┌───────────────────┐
          │  Pi Model Policy  │  ◄── Clasifica rol (REASON) + Consulta modelos
          └─────────┬─────────┘      y desempata por menor costo
                    │
                    │ 2. Inyecta modelo óptimo (openai-codex/gpt-5.6-terra:medium)
                    ▼
          ┌───────────────────┐
          │   pi-subagents    │  ◄── Ejecuta el subagente con el modelo asignado
          └───────────────────┘
```

---

## 1. Por qué existe: El problema del sobreconsumo

En una instalación moderna de Pi coexisten modelos de distinta escala y costo:
* Modelos ultrarrápidos y económicos: *GPT-5.6 Luna*, *Gemini 3.8 Flash*, *Claude Haiku*.
* Modelos de trabajo y desarrollo: *GPT-5.5*, *Gemini 3.1 Pro*, *Claude Sonnet 4.6*.
* Modelos de razonamiento profundo y arquitectura: *GPT-5.6 Sol*, *Claude Opus 4.6*.
* Modelos de frontera y arbitraje: *GPT-6 Astra*, *OpenAI o3*.

Cuando un framework multiagente como **Compound Engineering** o **SDD** lanza enjambres de subagentes especializados (investigadores, analizadores de repositorio, revisores de seguridad, redactores de planes), ocurren dos problemas graves sin un enrutador:

1. **Quema de cuota innecesaria:** Si tu sesión principal está en un modelo caro (como Sol u Opus), cada subagente que no tenga configuración propia heredará ese mismo modelo. Una sola revisión de código con 5 reviewers puede consumir en segundos la cuota de toda una semana.
2. **Saturación de un único proveedor:** La mayoría de herramientas saturan un solo proveedor hasta topar con límites de tasa (HTTP 429), mientras las cuentas de otros proveedores permanecen completamente ociosas.

Pi Model Policy resuelve ambos problemas convirtiendo tu conjunto de modelos en un **pool inteligente de capacidad distribuida**.

---

## 2. Principio rector: 6 Tiers de Capacidad

La extensión no piensa en nombres comerciales de modelos; piensa en **niveles de capacidad de trabajo** (*tiers*):

| Tier | Propósito y Carga de Trabajo | Ejemplos de Subagentes | Tipo de Modelo Asignado |
| :--- | :--- | :--- | :--- |
| **`FAST`** | Sondeos ultrarrápidos, filtros superficiales y comprobaciones de presencia. | `scout`, `quick-check` | El modelo estándar más rápido y económico disponible (thinking bajo o apagado). |
| **`RESEARCH`** | Rastreo de documentación, lectura de historial git, búsqueda web y recolección de contexto. | `researcher`, `ce-git-history-analyzer`, `ce-repo-research-analyst` | Modelos de bajo costo optimizados para lectura con ventanas de contexto amplias. |
| **`BUILD`** | Implementación de código, edición de archivos, ejecución de comandos y refactors cotidianos. | `worker`, `coder`, `implementer`, `gentle-ai-worker` | Modelos de desarrollo con sólida capacidad de tool-calling y costo moderado. |
| **`REASON`** | Revisión crítica de código, auditorías de seguridad, correctitud lógica y validación de invariantes. | `reviewer`, `ce-security-reviewer`, `ce-correctness-reviewer` | Modelos con capacidad nativa de razonamiento analítico (*reasoning*). |
| **`ARCHITECT`** | Diseño estructural de sistemas, redacción de especificaciones y planificación de alto nivel. | `ce-architecture-strategist`, `planner`, `spec-analyzer` | Modelos pensantes de gran capacidad lógica del segmento superior. |
| **`ORACLE`** | Arbitraje definitivo en decisiones de alto riesgo, desempate de paneles y consejo de frontera. | `oracle`, `advisor` | Los modelos de frontera más potentes del usuario (reservados exclusivamente para este rol). |

---

## 3. Arquitectura y Flujo de Funcionamiento

El funcionamiento de Pi Model Policy opera en dos ciclos independientes:

### A. Ciclo de Autodescubrimiento (Al iniciar la sesión)

Al arrancar Pi o recargar con `/reload`, la extensión inspecciona el registro en vivo provisto por el runtime:

```text
                   ctx.modelRegistry.getAvailable()
                                  │
                                  ▼
      ┌───────────────────────────────────────────────────────┐
      │   Extracción de Métricas Nativas de Pi (Sin Hardcode) │
      │   • Costo ponderado: 0.75 * input + 0.25 * output     │
      │   • Capacidad de razonamiento: model.reasoning        │
      │   • Ventana de contexto: model.contextWindow          │
      └───────────────────────────┬───────────────────────────┘
                                  │
                                  ▼
      ┌───────────────────────────────────────────────────────┐
      │          Partición Relativa en Dos Pools              │
      │                                                       │
      │   Pool Estándar (reasoning: false)                    │
      │   Ordenado por costo ascendente                       │
      │   ──► Cubre FAST, RESEARCH y BUILD                    │
      │                                                       │
      │   Pool Pensante (reasoning: true)                     │
      │   Ordenado por costo y bandas funcionales             │
      │   ──► Cubre REASON, ARCHITECT y ORACLE                │
      └───────────────────────────────────────────────────────┘
```

### B. Ciclo de Despacho en Vuelo (Por cada subagente)

Cuando cualquier herramienta dispara una llamada al tool `subagent`:

```text
                  Llamada a tool: subagent
                             │
                             ▼
               ¿event.input.model ya está fijado?
               ├── SÍ ──► Respeta el modelo del usuario (Bypass)
               │
               └── NO ──► Proceso de Enrutamiento Automático:
                             │
                             ├─► 1. Clasificación Heurística:
                             │      Analiza nombre, descripción y herramientas requeridas.
                             │      (write/bash ──► BUILD | read/grep ──► RESEARCH)
                             │
                             ├─► 2. Estimación de Carga de Tokens:
                             │      Si task > 30.000 tokens ──► Promueve a ventana de 1.0M
                             │
                             ├─► 3. Verificación de Circuit Breaker:
                             │      Omite proveedores en cooldown por rate-limit reciente.
                             │
                             ├─► 4. Selección por Menor Costo:
                             │      Elige el modelo más económico del tier y prepara fallbacks.
                             │
                             ▼
               Mutación in-flight de event.input.model
               ("openai-codex/gpt-5.6-terra:medium")
                             │
                             ▼
               pi-subagents ejecuta el proceso hijo
```

### C. Ciclo de Resiliencia (Circuit Breaker Post-Ejecución)

Si un proveedor sufre saturación de cuota o rate limits durante la sesión:

```text
                  pi.on("tool_result")
                             │
                             ▼
               ¿isError === true?
               ├── NO  ──► Ignora y continúa (inmunidad a falsos positivos)
               │
               └── SÍ  ──► ¿Contiene 429, 'rate limit' o 'quota exceeded'?
                             │
                             ├── SÍ ──► Activa Cooldown de 10 minutos
                             │          para ese proveedor en memoria.
                             │          Las siguientes llamadas usarán
                             │          automáticamente el fallback.
                             │
                             └── NO  ──► Error común de código (no penaliza)
```

---

## 4. Los 3 Perfiles de Enrutamiento

Puedes alternar la estrategia general de la flota según la situación de tu proyecto:

### Balanced (Predeterminado)
Equilibrio óptimo entre costo y precisión técnica. Las tareas rutinarias y de desarrollo usan modelos estándar rápidos de bajo costo, mientras que las revisiones de seguridad y arquitectura reciben modelos dedicados con *thinking* medio o alto.

### Quota-Saver (Modo Ahorro Estricto)
Ideal para fines de mes o cuando tienes saldo limitado en tus cuentas de API.
* Reduce los niveles de *thinking* a `off` o `low`.
* El tier `REASON` se atiende con modelos ligeros de bajo costo en lugar de modelos pesados.
* `ARCHITECT` y `ORACLE` descienden un escalón hacia modelos intermedios para proteger los modelos de frontera más caros.

### Quality (Modo Producción y Máximo Rigor)
Ideal para auditorías de seguridad previas a un release a producción, refactors en módulos críticos (pagos, autenticación) o depuración de bugs de concurrencia.
* Eleva el nivel de *thinking* a `high` o `max` en todos los tiers analíticos.
* Tareas de investigación documental (`RESEARCH`) suben de modelos ligeros a modelos pensantes para no omitir detalles sutiles.
* `REASON` y `ARCHITECT` reciben los modelos pensantes de mayor calibre del usuario.

---

## 5. Uso y Comandos en Terminal

La extensión registra el comando interactivo `/model-policy` con autocompletado contextual mediante la tecla `Tab`:

### Ver el estado activo del enrutador
```bash
/model-policy status
```
Genera un reporte estructurado en dos tablas independientes:
1. **Asignación por Tiers:** Muestra qué modelo primario, nivel de *thinking*, costo y fallbacks tiene asignado cada uno de los 6 tiers.
2. **Catálogo de Modelos Autodescubiertos:** Lista todos los modelos que Pi detectó en tus cuentas, clasificados por categoría funcional (*Estándar*, *Pensante*, *Estructural*, *Frontera*), costo real por millón de tokens y tamaño de ventana de contexto.
3. **Salud de Proveedores:** Informa si todos los proveedores están saludables o si alguno se encuentra en período de enfriamiento.

### Consultar o cambiar de perfil
```bash
# Ver el perfil actual y las opciones disponibles
/model-policy profile

# Cambiar a modo ahorro estricto
/model-policy profile quota-saver

# Cambiar a modo máxima precisión
/model-policy profile quality

# Restablecer modo equilibrado
/model-policy profile balanced
```

### Auditar la decisión sobre un subagente
```bash
/model-policy explain ce-security-reviewer
```
Imprime el árbol de decisión paso a paso para ese agente:
* Por qué cayó en ese tier (heurística de nombre, herramientas declaradas u override).
* Qué modelo primario se le asignó y con qué nivel de *thinking*.
* Qué modelos forman su cadena de respaldo (*fallbacks*).
* Si algún proveedor fue excluido preventivamente por errores de cuota recientes.

### Inspeccionar enfriamientos activos
```bash
/model-policy cooldowns
```
Muestra qué proveedores están bajo enfriamiento temporal (10 minutos) y cuántos segundos restan antes de que vuelvan a ser elegibles automáticamente.

---

## 6. Configuración Opcional y Overrides Manuales

La extensión funciona al 100% de forma autónoma sin necesidad de archivos de configuración. No obstante, si deseas fijar reglas específicas, puedes crear un archivo JSON en:
* Nivel global: `~/.pi/agent/model-policy.json`
* Nivel de proyecto: `.pi/model-policy.json` *(tiene precedencia sobre el global)*

```json
{
  "profile": "balanced",
  "tiers": {
    "build": "antigravity/gemini-3.8-flash",
    "reason": "openai-codex/gpt-5.6-terra"
  },
  "agents": {
    "ce-security-reviewer": {
      "tier": "reason"
    },
    "mi-agente-especial": {
      "model": "openai-codex/gpt-5.6-sol:high"
    }
  }
}
```

### Jerarquía de resolución de modelos
```text
1. Modelo explícito en el prompt o invocación  (Bypass manual)
2. Override específico para el agente en JSON  (agents[name].model)
3. Override de tier para el agente en JSON    (agents[name].tier)
4. Override de tier global en JSON             (tiers[tier])
5. Resolución dinámica por menor costo        (Autodescubrimiento nativo)
```

---

## 7. Invariantes de Seguridad y Resiliencia

1. **Cheap by Default:** Un subagente desconocido jamás se enruta a modelos caros como ARCHITECT u ORACLE por descarte; siempre recibe el tier base FAST o BUILD.
2. **Prohibición de Escalado Ascendente:** Si un modelo falla por cuota o rate limit, la degradación de fallback solo puede buscar modelos de igual o menor costo. Nunca escala hacia modelos más caros.
3. **Inmunidad a Falsos Positivos:** El Circuit Breaker exige que la herramienta haya reportado fallo de ejecución antes de analizar códigos de error, impidiendo que código legítimo que mencione "429" o "overloaded" bloquee a un proveedor.
4. **Memoria Acotada:** El historial de explicabilidad y decisiones en memoria utiliza una política de desalojo FIFO estricta (máximo 50 entradas) para evitar fugas de memoria en sesiones persistentes de terminal.
