---
name: git-delta-safe-config
description: "Trigger: configurar git, git alias, delta config, lazygit config, delta theme, git delta safe. Garantiza la configuración no destructiva de Git y Delta mediante include.path sin tocar credenciales."
---

# Git & Delta Safe Config Skill

Esta skill define las reglas de seguridad y diseño modular para la configuración de Git, Git-Delta y Lazygit en **OhMyConfig**.

---

## Principio de No Destructividad

1. **Invariante de Credenciales:**
   - La configuración de OhMyConfig **NUNCA** debe sobreescribir ni modificar directamente el archivo `~/.gitconfig` del usuario.
   - El nombre (`user.name`), correo electrónico (`user.email`), claves de firmado GPG/SSH (`user.signingkey`) y tokens de autenticación de GitHub deben permanecer intactos y privados.

2. **Patrón `include.path`:**
   - Toda la configuración de estilos Tokyonight, Delta pager y aliases vive exclusivamente dentro del archivo versionado:
     ```text
     config/git/delta.gitconfig
     ```
   - El instalador `deploy.sh` vincula este archivo agregando una directiva de inclusión en `~/.gitconfig`:
     ```ini
     [include]
         path = ~/.config/git/delta.gitconfig
     ```

---

## Configuración Canónica de Delta (`delta.gitconfig`)

```ini
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true
    line-numbers = true
    side-by-side = false
    syntax-theme = TwoDark
    minus-style = syntax "#3b222c"
    minus-emph-style = syntax "#702d3d"
    plus-style = syntax "#1c333b"
    plus-emph-style = syntax "#2e5c54"
    line-numbers-minus-style = "#f7768e"
    line-numbers-plus-style = "#9ece6a"
    line-numbers-left-style = "#7a88cf"
    line-numbers-right-style = "#7a88cf"
    line-numbers-zero-style = "#565f89"

[alias]
    lg = "log --graph --pretty=format:'%C(bold #7dcfff)%h%C(reset) - %C(bold #c099ff)%d%C(reset) %C(#e0e6fc)%s%C(reset) %C(#7a88cf)(%cr)%C(reset) %C(bold #7aa2f7)<%an>%C(reset)' --abbrev-commit --date=relative"
    lga = "log --graph --all --pretty=format:'%C(bold #7dcfff)%h%C(reset) - %C(bold #c099ff)%d%C(reset) %C(#e0e6fc)%s%C(reset) %C(#7a88cf)(%cr)%C(reset) %C(bold #7aa2f7)<%an>%C(reset)' --abbrev-commit --date=relative"
```

---

## Integración con Lazygit (`config/lazygit/config.yml`)

Lazygit debe renderizar diffs usando el pager de Delta:
```yaml
git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
```

---

## Protocolo de Modificación

1. Solo editar `config/git/delta.gitconfig` o `config/lazygit/config.yml`.
2. Verificar con `git diff` interactivo y `git lg` que el renderizado de colores y números de línea sea impecable.
3. Asegurar que ningún dato de autoría personal sea incluido en los archivos versionados.
