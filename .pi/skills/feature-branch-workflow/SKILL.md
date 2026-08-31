---
name: feature-branch-workflow
description: "Trigger: nueva rama, feature branch, crear rama, preparar pr, merge a main, git branch flow. Guía el ciclo de vida de ramas de trabajo y su integración segura a main."
---

# Feature Branch Workflow Skill

Esta skill define el ciclo de vida para trabajar con ramas de Git en **OhMyConfig**, asegurando que la rama principal `main` permanezca siempre verde, validada y lista para despliegue continuo en GitHub Pages.

---

## Modelo de Ramas

* **`main`**: Rama de producción y estabilidad. Todo push a `main` en las rutas `docs/**` o `.vitepress/**` dispara el despliegue automático a GitHub Pages (`.github/workflows/docs.yml`).
* **`feature/<nombre>`**: Ramas de trabajo para nuevas funcionalidades, refactorizaciones o mejoras de CLI (ej: `feature/cli`, `feature/snapshots`).
* **`fix/<nombre>`**: Ramas para corrección de errores puntuales (ej: `fix/zellij-keybinds`).
* **`docs/<nombre>`**: Ramas dedicadas a expansiones mayores de documentación.

---

## Protocolo de Trabajo Paso a Paso

### 1. Creación de la Rama
```bash
git checkout main
git pull origin main
git checkout -b feature/<nombre-descriptivo>
```

### 2. Desarrollo Atómico
* Realizar commits frecuentes y estructurados siguiendo el estándar de `conventional-commit-curator`.
* Mantener los cambios enfocados exclusivamente en el objetivo de la rama.

### 3. Puerta de Validación Pre-Merge (*Pre-Merge Gate*)
Antes de fusionar a `main` o abrir un Pull Request, ejecutar obligatoriamente:
1. **Validación de Scripts:**
   ```bash
   bash -n omc cli/lib/*.sh cli/commands/*.sh
   ```
2. **Diagnóstico del Entorno:**
   ```bash
   ./omc doctor
   ```
3. **Compilación de Documentación:**
   ```bash
   npx vitepress build
   ```

### 4. Integración Limpia hacia `main`
1. Sincronizar con el estado más reciente de `main`:
   ```bash
   git fetch origin
   git rebase origin/main
   ```
2. Realizar el merge o push a la rama remota para revisión:
   ```bash
   git push -u origin feature/<nombre>
   ```
