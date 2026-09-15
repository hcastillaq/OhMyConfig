---
title: "Guía Maestra de Git y Control de Versiones"
description: "Flujo integrado con lazygit, git-delta y diffs visuales bajo Static Noise."
---

El control de versiones es donde pasamos gran parte del día. En lugar de tipear comandos largos o depender de interfaces pesadas que te sacan de la consola, en OhMyConfig armé un flujo de tres niveles:

1. **Alias rápidos de consola (`gs`, `gc`, `gd`, `gl`):** Para las operaciones del segundo a segundo (ver estado, commitear, inspeccionar el diff inmediato).
2. **Diffs visuales con Delta (`git-delta`):** Cada vez que corrés un `git diff` o mirás el log, Delta te muestra el código coloreado con sintaxis de verdad, números de línea y soporte para el tema **Static Noise**.
3. **Interfaz TUI con Lazygit (`lg`):** Cuando necesitás granularidad visual (hacer stage de líneas sueltas, editar un commit anterior, navegar ramas o resolver conflictos de merge complejos sin dolor).

```
┌────────────────────────────────────────────────────────────────────────┐
│                        FLUJO INTEGRADO DE GIT                          │
├──────────────────┬──────────────────┬─────────────────┬────────────────┤
│   TERMINAL CLI   │    TUI VISUAL    │   DIFFS DELTA   │   TELEMETRÍA   │
│ g, gs, gc, gl, gd│  lazygit (`lg`)  │   git-delta     │ onefetch (`of`)│
└──────────────────┴──────────────────┴─────────────────┴────────────────┘
```

---

## 1. Atajos Esenciales en Consola

| Atajo | Comando Real | Propósito / Caso de Uso |
| :--- | :--- | :--- |
| **`gs`** | `git status` | Ver estado de archivos (staged, unstaged, untracked). |
| **`gaa`** | `git add .` | Agregar todos los cambios al staging area. |
| **`gc`** | `git commit` | Abrir Neovim para redactar un commit estructurado. |
| **`gch <branch>`** | `git checkout <branch>` | Cambiar de rama o restaurar archivos de trabajo. |
| **`gd`** | `git diff` | Ver cambios pendientes con resaltado de sintaxis **Delta**. |
| **`gp`** | `git push` | Subir la rama activa al repositorio remoto. |
| **`g`** | `git` | Acceso directo al binario de Git. |

---

## 2. Visualización de Historial y Árboles de Commits

### `gl` — Árbol de commits de la rama actual
Muestra el grafo de bifurcación, hash corto en cyan (`#72EAD5`), referencias de ramas/tags en púrpura (`#C2A7FF`), mensaje en marfil (`#E6E2D6`), tiempo relativo en gris (`#9299AE`) y autor en azul (`#83BFFF`).
```bash
gl
```

### `glog` — Árbol completo de todas las ramas
Incluye todas las ramas locales y remotas (`--all`) para entender cómo convergen los merges y rebases.
```bash
glog
```

### `glp` — Historial detallado con diffs en Delta
Recorre los commits mostrando el diff completo de código línea por línea con resaltado de sintaxis.
```bash
glp
```

---

## 3. Interfaz Visual con Lazygit (`lg`)

**Lazygit** es la herramienta central cuando un flujo de Git requiere granularidad visual (hacer staging de líneas sueltas, resolver conflictos o editar commits pasados).

```bash
lg
```

```
┌─────────┬───────────────────────────────┬──────────────────────────────┐
│ [1]     │ [3] Branches                  │ [Main Panel]                 │
│ Status  │ * main                        │                              │
├─────────┤   feature/auth                │ Diff enriquecido con Delta   │
│ [2]     ├───────────────────────────────┤ y opciones de navegación     │
│ Files   │ [4] Commits                   │                              │
│ [x] src │ * 008e985 feat: add layout    │                              │
└─────────┴───────────────────────────────┴──────────────────────────────┘
```

### Atajos Clave en Lazygit:
* **Navegación entre paneles:** Teclas `1`, `2`, `3`, `4`, `5` o `Tab` / `Shift+Tab`.
* **Staging de archivo o línea:** Barra espaciadora (`Space`).
* **Hacer Commit:** Tecla `c` $\rightarrow$ escribir mensaje $\rightarrow$ `Enter`.
* **Subir cambios (Push):** Tecla `P` (Shift + P).
* **Bajar cambios (Pull):** Tecla `p`.
* **Menú de ramas / Crear rama:** En el panel `[3]`, tecla `n` para nueva rama o `Space` para checkout.
* **Descartar cambios de archivo:** Tecla `d`.
* **Menú de ayuda:** Tecla `?`.

---

## 4. Radiografía de Repositorios con Onefetch (`of`)

Genera un resumen gráfico con estadísticas de lenguajes, líneas de código, commits, autor principal y estado de la licencia:

```bash
of
```

---

## 5. Refactorización Rápida en Repositorios (`rg` + `sd` + `fd`)

Combiná las utilidades en Rust para realizar cambios masivos seguros en todo el código:

1. **Buscar ocurrencias con `ripgrep` (`rg`):**
   ```bash
   rg "API_URL_LEGACY"
   ```
2. **Reemplazar masivamente en archivos con `sd`:**
   ```bash
   sd 'https://api-v1.internal' 'https://api-v2.internal' src/**/*.ts
   ```
3. **Buscar archivos y ejecutar transformaciones con `fd`:**
   ```bash
   fd -e json -x prettier --write {}
   ```
