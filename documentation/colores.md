# Paleta Tokyonight Night

OhMyConfig usa **Tokyonight Night** como paleta base para mantener una interfaz oscura, legible y coherente entre el terminal, editor y herramientas TUI.

## Colores base

| Rol | Color | Uso principal |
| --- | --- | --- |
| Fondo | `#1a1b26` | Fondo principal |
| Fondo profundo | `#16161e` | Marcos y superficies profundas |
| Fondo resaltado | `#292e42` | Superficies secundarias y bordes inactivos |
| Texto | `#c0caf5` | Texto principal |
| Texto secundario | `#a9b1d6` | Texto auxiliar |
| Comentarios | `#565f89` | Comentarios y contenido atenuado |
| Azul | `#7aa2f7` | Títulos, ramas y acciones primarias |
| Cian | `#7dcfff` | Foco activo, enlaces y cursor |
| Verde | `#9ece6a` | Éxitos y añadidos |
| Amarillo | `#e0af68` | Avisos y elementos pendientes |
| Naranja | `#ff9e64` | Runtimes, números y constantes |
| Magenta | `#bb9af7` | Acentos secundarios y palabras clave |
| Rojo | `#f7768e` | Errores y eliminados |

## Extensiones high-contrast

Estos tonos amplían la paleta base para estados que deben distinguirse claramente sobre un fondo oscuro o transparente. No reemplazan los colores base.

| Rol | Color | Uso principal |
| --- | --- | --- |
| Selección | `#3d59a1` | Fondo de texto, fila o elemento seleccionado |
| Texto seleccionado | `#ffffff` | Texto sobre la selección |
| Cian intenso | `#50f5ff` | Foco o énfasis excepcional |
| Púrpura intenso | `#c099ff` | Pestañas y acentos destacados |
| Texto brillante | `#e0e6fc` | Texto de máximo contraste |
| Azul atenuado | `#7a88cf` | Metadatos y contenido secundario visible |
| Azul grisáceo | `#636f8f` | Estados inactivos legibles |
| Cian suave | `#b4f9f8` | Énfasis claro complementario |
| Fondo de selección suave | `#283457` | Selección secundaria cuando `#3d59a1` resulte excesivo |
| Fondo elevado | `#1f2335` | Superficies elevadas y diffs |
| Fondo alternativo | `#24283b` | Paneles y superficies alternativas |
| Fondo de diff | `#2e3c64` | Contexto de diff o selección moderada |

## Aplicación por herramienta

| Herramienta | Archivos | Roles relevantes |
| --- | --- | --- |
| Ghostty | `config/ghostty/config` | Fondo, cursor y selección de alto contraste |
| Neovim | `config/nvim/lua/plugins/colorscheme.lua` | Tema Night, transparencias y highlights |
| Fish y FZF | `config/fish/config.fish` | Sintaxis, interfaz de búsqueda y selección |
| Starship | `config/starship/starship.toml` | Segmentos del prompt |
| Zellij | `config/zellij/config.kdl` | Tema, panel activo e inactivo |
| zjstatus | `config/zellij/layouts/default.kdl` | Barra de estado y pestañas |
| Lazygit | `config/lazygit/config.yml` | Bordes, selección y estado Git |
| Bottom | `config/bottom/bottom.toml` | Texto, gráficos, tabla y selección |
| Git Delta | `config/git/delta.gitconfig` | Tema de sintaxis y diffs |

## Reglas de uso

1. Usa los colores base antes que una extensión high-contrast.
2. Usa `#3d59a1` con `#ffffff` para una selección que deba permanecer visible sobre fondos oscuros.
3. Mantén los colores de éxito, aviso y error: verde, amarillo y rojo, respectivamente.
4. Conserva la sintaxis propia de cada herramienta: Fish usa hex sin `#` en sus variables; FZF, TOML, YAML, KDL, Lua y Git config usan códigos hexadecimales completos según su formato.
5. Al añadir una herramienta con color explícito, incorpora aquí su archivo y roles antes de desplegarla.
