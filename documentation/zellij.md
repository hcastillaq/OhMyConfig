# 🪟 Guía Maestra de Zellij (`zj`)

Zellij es un multiplexor de terminal moderno escrito en **Rust**, configurado en OhMyConfig con un layout de **1 sola línea inferior** (`layouts/default.kdl`) utilizando el plugin local **`zjstatus.wasm`** y la paleta **Static Noise**:

```text
┌────────────────────────────────────────────────────────────────────────┐
│ [Panel 1: Neovim] (Cyan Brillante #7dcfff)  │ [Panel 2: Tests / Logs] │
│                                             │                         │
├────────────────────────────────────────────────────────────────────────┤
│ NORMAL │ 1: dev  2: git                     │ ⚡ session │ 🕒 14:30    │
└────────────────────────────────────────────────────────────────────────┘
```

* **Resaltado de Foco de Alto Contraste:** El panel activo se ilumina instantáneamente con bordes redondeados en **Cyan Static Noise (`#72EAD5`)** y cabecera en **Azul (`#83BFFF`)**, mientras los paneles inactivos permanecen en un tono oscuro discreto (`#343A4A`).
* **Selección Visible:** Los componentes modernos de Zellij (`text_selected`, `list_selected`, `table_cell_selected`, `ribbon_selected`) usan contraste alto Static Noise: texto claro sobre **CyanDim selección (`#193C3B`)** o texto oscuro sobre **Cyan (`#72EAD5`)**, para que menús, listas, búsqueda y ribbons activos se distingan sin perder coherencia visual.

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
| **Session** | **`Alt + o`** | `Esc`, `Enter` o `Alt + o` | Detach, session manager, configuración y plugin manager |

---

## 3. Modo Pane (`Alt + p`)

| Tecla dentro del modo | Acción |
| :---: | :--- |
| **`h/j/k/l`** o flechas | Mover foco entre paneles |
| **`n`** / **`d`** | Crear nuevo panel abajo |
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
  - **`h/l`**, `PageUp` / `PageDown`: página arriba / abajo.
  - **`s`**: buscar texto en el historial.
  - **`e`**: abrir el historial en Neovim.
  - **`c`**: copiar la última salida de comando.
* **Modo Session (`Alt + o`):**
  - **`d`**: desconectarse (*Detach*).
  - **`w`**: abrir el gestor de sesiones.
  - **`c`**: abrir configuración.
  - **`p`**: abrir plugin manager.
