---
title: "Guía Maestra de Zellij"
description: "Multiplexor moderno en Rust con barra unificada zjstatus.wasm y navegación por paneles."
---

Zellij es mi multiplexor de terminal favorito. Si venís de Tmux, sabés lo tedioso que puede ser configurar una barra de estado que no dependa de diez scripts frágiles en bash. 

Zellij está escrito en **Rust**, vuela en rendimiento y en OhMyConfig lo configuré con dos principios clave:
1. **Atajos Alt-first sin conflictos:** Limpié los atajos por defecto con `clear-defaults=true`. Zellij jamás te va a interceptar una combinación con `Ctrl` que uses en Neovim o en la shell; todo el control de paneles y pestañas se hace con `Alt` / `Option`.
2. **Barra de estado de 1 sola línea:** Uso el plugin local compilado en WebAssembly **`zjstatus.wasm`** para unificar pestañas, modo activo y sesión en una línea mínima al pie, dejándote el 98% de la pantalla para programar.

```text
┌────────────────────────────────────────────────────────────────────────┐
│ [Panel 1: Neovim] (Cyan Static Noise #72EAD5) │ [Panel 2: Tests / Logs] │
│                                             │                         │
├────────────────────────────────────────────────────────────────────────┤
│ NORMAL │ 1: dev  2: git                     │ session │ 14:30    │
└────────────────────────────────────────────────────────────────────────┘
```

* **Foco de alto contraste:** El panel donde estás parado se ilumina con bordes en **Cyan Static Noise (`#72EAD5`)** y cabecera en **Azul (`#83BFFF`)**, mientras los paneles inactivos quedan en un gris oscuro discreto (`#343A4A`).
* **Selección clara:** Listas, menús y scrollback usan contraste estricto sobre fondos atenuados (`#193C3B`) para que siempre sepas qué estás seleccionando.

---

## 1. Mapa principal Alt-first *(sin conflictos con `Ctrl`)*

OhMyConfig limpia los atajos por defecto de Zellij con `clear-defaults=true`. Zellij ya no captura combinaciones `Ctrl` comunes de Neovim, Fish, readline u otras TUIs; el flujo diario vive en **`Alt` / `Option`**.

| Qué querés hacer | Atajo | Explicación |
| :--- | :--- | :--- |
| **Mover foco entre paneles** | **`Alt + h/j/k/l`** o flechas | Salta el foco a izquierda, abajo, arriba o derecha |
| **Crear nuevo panel** | **`Alt + n`** | Crea un panel nuevo directamente |
| **Cerrar panel activo** | **`Alt + x`** | Cierra el panel actual |
| **Maximizar / restaurar panel** | **`Alt + f`** | Alterna pantalla completa del panel activo |
| **Alternar paneles flotantes** | **`Alt + w`** | Muestra u oculta los paneles flotantes |
| **Mover panel físicamente** | **`Alt + Shift + h/j/k/l`** | Reubica el panel activo en esa dirección |
| **Pestaña anterior / siguiente** | **`Alt + [`** / **`Alt + ]`** | Cambia de pestaña al instante |
| **Crear nueva pestaña** | **`Alt + t`** | Abre una tab nueva |
| **Cerrar pestaña actual** | **`Alt + q`** | Cierra la tab activa |
| **Renombrar pestaña** | **`Alt + r`** | Entra al prompt de renombrado de tab |
| **Saltar a pestaña N** | **`Alt + 1` .. `Alt + 9`** | Va directo a la pestaña indicada |
| **Detach rápido** | **`Alt + d`** | Desconecta la sesión dejando procesos vivos |

---

## 2. Entrada a modos de Zellij *(fallback con `Alt`)*

Los modos siguen disponibles para operaciones menos frecuentes, pero ya no usan prefijos `Ctrl`:

| Modo | Entrada | Salida | Para qué sirve |
| :--- | :--- | :--- | :--- |
| **Pane** | **`Alt + p`** | `Esc`, `Enter` o `Alt + p` | Crear/cerrar paneles, fullscreen, floating y frames |
| **Tab** | **`Alt + Shift + t`** | `Esc`, `Enter` o `Alt + Shift + t` | Crear/cerrar tabs, renombrar, sync input y saltos numerados |
| **Move** | **`Alt + m`** | `Esc`, `Enter` o `Alt + m` | Mover físicamente el panel activo |
| **Resize** | **`Alt + z`** | `Esc`, `Enter` o `Alt + z` | Ajustar tamaño de paneles |
| **Scroll** | **`Alt + s`** | `Esc`, `Enter` o `Alt + s` | Revisar historial, buscar y editar scrollback |
| **Session** | **`Alt + o`** | `Esc`, `Enter` o `Alt + o` | Detach, session manager y plugin manager |

---

## 3. Modo Pane (`Alt + p`)

| Tecla dentro del modo | Acción |
| :---: | :--- |
| **`h/j/k/l`** o flechas | Mover foco entre paneles |
| **`n`** | Crear nuevo panel |
| **`d`** | Crear nuevo panel abajo |
| **`r`** | Crear nuevo panel a la derecha |
| **`x`** | Cerrar el panel activo |
| **`f`** | Alternar fullscreen |
| **`w`** | Alternar paneles flotantes |
| **`z`** | Mostrar / ocultar marcos de paneles |
| **`Esc`**, **`Enter`** o **`Alt + p`** | Volver a Normal |

---

## 4. Modo Tab (`Alt + Shift + t`)

| Tecla dentro del modo | Acción |
| :---: | :--- |
| **`h/l`**, **`k/j`** o flechas | Ir a tab anterior / siguiente |
| **`n`** | Crear nueva pestaña |
| **`x`** | Cerrar pestaña actual |
| **`r`** | Renombrar pestaña |
| **`s`** | Sincronizar entrada en todos los paneles de la tab |
| **`1` .. `9`** | Saltar a la pestaña número N |
| **`Esc`**, **`Enter`** o **`Alt + Shift + t`** | Volver a Normal |

---

## 5. Move, Resize, Scroll y Session

* **Modo Move (`Alt + m`):**
  - **`h/j/k/l`** o flechas: mover el panel activo en esa dirección.
  - **`Tab`** / **`n`**: intercambiar con el siguiente panel.
  - **`p`**: intercambiar con el panel anterior.
* **Modo Resize (`Alt + z`):**
  - **`h/j/k/l`** o flechas: aumentar tamaño hacia esa dirección.
  - **`H/J/K/L`**: reducir tamaño desde esa dirección.
  - **`+`** / **`-`**: aumentar o reducir tamaño general.
* **Modo Scroll y búsqueda (`Alt + s`):**
  - **`j/k`**: scrollear línea por línea.
  - **`d/u`**: media página abajo / arriba.
  - **`b`** / **`f`**, `PageUp` / `PageDown`: página arriba / abajo.
  - **`s`**: buscar texto en el historial.
  - **`e`**: abrir el historial en Neovim.
* **Modo Session (`Alt + o`):**
  - **`d`**: desconectarse (*Detach*).
  - **`w`**: abrir el gestor de sesiones.
  - **`p`**: abrir plugin manager.
