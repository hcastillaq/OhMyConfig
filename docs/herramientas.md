# 🧰 Herramientas Modernas CLI / TUI

OhMyConfig sustituye las herramientas tradicionales de Unix por utilidades modernas escritas en **Rust** y **Go**.

---

## 1. Navegación & Exploración

### **zoxide (`cd` / `z`)**
* `cd <nombre>`: Salta a cualquier directorio frecuente sin importar cuán profundo esté.
* `zi`: Menú interactivo con FZF para elegir directorios históricos.
* Abreviaturas: `..` (sube 1 nivel), `...` (sube 2 niveles), `-` (vuelve al previo).

### **fzf**
* Motor de búsqueda difusa con colores Tokyonight Night y cursor `▶`.
* `Ctrl + t`: Búsqueda difusa de archivos con `fd` (ignora `.git` y `node_modules`).
* `Alt + c`: Búsqueda difusa y cambio directo a carpetas.

### **yazi (`y` / `yz`)**
* Administrador de archivos TUI asíncrono con vista previa de texto e imágenes.
* Usá el alias `y` para que al salir con `q` tu terminal quede ubicada en la carpeta explorada.

### **eza & bat**
* `ls`, `ll`, `la`, `tree`: Listados visuales con íconos y carpetas agrupadas primero.
* `cat`: Visor con sintaxis coloreada Tokyonight y marcas de Git.

---

## 2. APIs, Datos y JSON

### **xh**
* Cliente HTTP ergonómico y veloz (reemplazo moderno de `curl`).
* `xh GET api.github.com/users/octocat`
* `xh POST httpbin.org/post name="Gentleman" role="Architect"`

### **jq & jqp**
* `jq`: Procesamiento y formateo de streams JSON por consola.
* `jqp`: Playground TUI interactivo para probar filtros de `jq` en tiempo real:
  ```bash
  cat respuesta.json | jqp
  ```

---

## 3. Monitoreo, Procesos y Contenedores

### **bottom (`btm`)**
* Monitor gráfico en tiempo real de CPU por núcleo, Memoria/Swap, Red, Discos y Procesos.
* `t` (ordenar por CPU), `m` (ordenar por Memoria), `dd` (terminar proceso), `/` (filtrar).

### **procs**
* Reemplazo enriquecido de `ps`.
* `procs --port 3000`: Muestra qué proceso exacto está utilizando el puerto 3000.
* `procs --tree`: Vista en árbol de procesos.

### **dust (`du`)**
* Visualizador interactivo del espacio en disco en barras gráficas.
* `dust -d 2`: Análisis a 2 niveles de profundidad.

### **lazydocker & k9s**
* `lazydocker`: TUI para contenedores, imágenes, volúmenes y logs en vivo de Docker.
* `k9s`: Panel TUI para clusters de Kubernetes.
* `kubectx` / `kubens`: Alternar contextos y namespaces de Kubernetes interactivamente.
