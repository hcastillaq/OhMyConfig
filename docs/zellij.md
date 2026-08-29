# 🪟 Guía Maestra de Zellij (`zj`)

Zellij es un multiplexor de terminal moderno escrito en **Rust**, configurado en OhMyConfig con un layout de **1 sola línea inferior** (`layouts/default.kdl`) utilizando el plugin local **`zjstatus.wasm`** y la paleta **Tokyonight**:

```text
┌────────────────────────────────────────────────────────────────────────┐
│ [Panel 1: Neovim] (Cyan Brillante #7dcfff)  │ [Panel 2: Tests / Logs] │
│                                             │                         │
├────────────────────────────────────────────────────────────────────────┤
│ NORMAL │ 1: dev  2: git                     │ ⚡ session │ 🕒 14:30    │
└────────────────────────────────────────────────────────────────────────┘
```

* **Resaltado de Foco de Alto Contraste:** El panel activo se ilumina instantáneamente con bordes redondeados en **Cyan Tokyonight (`#7dcfff`)** y cabecera en **Azul (`#7aa2f7`)**, mientras los paneles inactivos permanecen en un tono oscuro discreto (`#292e42`).

---

## 1. Navegación Directa en Modo Normal *(Memoria Muscular con `Alt`)*

Podés moverte entre paneles y pestañas directamente **sin presionar ningún prefijo previo**:

| Qué querés hacer | Atajo | Explicación |
| :--- | :--- | :--- |
| **Mover foco entre paneles** | **`Alt + Flechas`** (o `Alt + hjkl`) | Salta de un panel a otro inmediatamente |
| **Pestaña anterior / siguiente** | **`Alt + [`** / **`Alt + ]`** | Cambia a la pestaña previa o siguiente |
| **Saltar directo a una pestaña** | **`Alt + 1` .. `Alt + 9`** | Salta a la pestaña número 1, 2, 3... |
| **Crear nueva pestaña** | **`Alt + t`** | Abre una nueva pestaña al instante |
| **Crear nuevo panel** | **`Alt + n`** | Divide la pantalla creando un nuevo panel |
| **Maximizar / Restaurar panel activo** | **`Alt + f`** | Alterna pantalla completa (*Toggle Fullscreen*) |
| **Alternar paneles flotantes** | **`Alt + w`** | Muestra/oculta paneles flotantes (*Floating Panes*) |

---

## 2. Gestión de Paneles (`Ctrl + p` $\rightarrow$ Modo `PANE`)

Presioná **`Ctrl + p`** (la barra inferior cambia a verde indicando `PANE` y mostrando los atajos):

| Tecla | Acción |
| :---: | :--- |
| **`n`** / **`d`** | Crear nuevo panel abajo (*Split Down*) |
| **`r`** | Crear nuevo panel a la derecha (*Split Right*) |
| **`x`** | Cerrar el panel activo |
| **`f`** | Alternar pantalla completa en el panel activo (*Fullscreen*) |
| **`w`** | Convertir panel en ventana flotante |
| **`z`** | Mostrar / Ocultar marcos de los paneles (*Toggle frames*) |
| **`Flechas`** (o `h/j/k/l`) | Mover el foco entre paneles |
| **`<Esc>`** o `<Enter>` | Salir del modo Paneles y volver a Normal |

---

## 3. Gestión de Pestañas (`Ctrl + t` $\rightarrow$ Modo `TAB`)

Presioná **`Ctrl + t`** (la barra inferior cambia a púrpura indicando `TAB`):

| Tecla | Acción |
| :---: | :--- |
| **`n`** | Crear **nueva pestaña** |
| **`x`** | **Cerrar pestaña** actual |
| **`h`** / **`l`** (o `←` / `→`) | Moverse a la **pestaña izquierda / derecha** |
| **`r`** | **Renombrar** la pestaña actual |
| **`s`** | **Sincronizar entrada:** lo que escribas se replica en todos los paneles a la vez |
| **`1` .. `9`** | Saltar a la pestaña número 1..9 |
| **`<Esc>`** o `<Enter>` | Salir del modo Pestañas y volver a Normal |

---

## 4. Redimensionar, Scroll y Búsqueda en Historial

* **Modo Redimensionar (`Ctrl + n`):**
  - **`+`** / **`-`**: Aumentar o reducir tamaño del panel activo.
  - **`h`**, **`j`**, **`k`**, **`l`**: Redimensionar hacia una dirección específica.
* **Modo Scroll y Búsqueda (`Ctrl + s`):**
  - **`j`** / **`k`** (o `↑` / `↓`): Scrollear línea por línea en el historial de la terminal.
  - **`d`** / **`u`**: Scrollear media página abajo / arriba (*Half-page*).
  - **`s`**: **Buscar texto en el historial** de la consola.
  - **`e`**: Abrir todo el historial de la terminal directamente en **Neovim** para editarlo o copiar texto cómodamente.
* **Modo Sesión (`Ctrl + o`):**
  - **`d`**: Desconectarse (*Detach*) de la sesión dejando los procesos corriendo de fondo.
  - **`w`**: Gestor interactivo de sesiones (*Session manager*).
