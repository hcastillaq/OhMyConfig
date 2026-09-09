---
name: git-delta-safe-config
description: "Trigger: configurar git, git alias, delta config, lazygit config, delta theme, git delta safe. Garantiza la configuración no destructiva de Git y Delta mediante include.path sin tocar credenciales."
---

# Git & Delta Safe Configuration Skill

Esta skill garantiza la configuración segura, no destructiva y modular de Git, Delta y Lazygit dentro del ecosistema OhMyConfig.

---

## Principio Fundamental: `include.path`

- **NUNCA** sobreescribir directamente `~/.gitconfig`.
- Toda la configuración de estilos Static Noise, Delta pager y aliases vive exclusivamente dentro del archivo versionado:
  `config/git/delta.gitconfig`
- El instalador (`cli/commands/install.sh`) enlaza este archivo en el `~/.gitconfig` del usuario mediante:
  ```bash
  git config --global --add include.path "~/.config/git/delta.gitconfig"
  ```
- Este enfoque preserva credenciales de usuario (`user.name`, `user.email`, llaves SSH/GPG) y configuraciones previas intactas.

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
    syntax-theme = ansi
    minus-style = syntax "#48262E"
    minus-emph-style = syntax "#6B2B38"
    plus-style = syntax "#293B2C"
    plus-emph-style = syntax "#3A5C3E"
    line-numbers-minus-style = "#EF7785"
    line-numbers-plus-style = "#A3D98B"
    line-numbers-left-style = "#9299AE"
    line-numbers-right-style = "#9299AE"
    line-numbers-zero-style = "#62697B"

[alias]
    lg = "log --graph --pretty=format:'%C(bold #72EAD5)%h%C(reset) - %C(bold #C2A7FF)%d%C(reset) %C(#E6E2D6)%s%C(reset) %C(#9299AE)(%cr)%C(reset) %C(bold #83BFFF)<%an>%C(reset)' --abbrev-commit --date=relative"
    lga = "log --graph --all --pretty=format:'%C(bold #72EAD5)%h%C(reset) - %C(bold #C2A7FF)%d%C(reset) %C(#E6E2D6)%s%C(reset) %C(#9299AE)(%cr)%C(reset) %C(bold #83BFFF)<%an>%C(reset)' --abbrev-commit --date=relative"
```

---

## Integración con Lazygit (`config/lazygit/config.yml`)

Lazygit debe renderizar diffs usando el pager de Delta:
```yaml
git:
  diffRenderers:
    - colorArg: always
      command: delta --dark --paging=never --line-numbers
```

---

## Procedimiento de Verificación

1. Verificar que `config/git/delta.gitconfig` contenga la sintaxis limpia de Delta sin información sensible.
2. Ejecutar `git diff` o `git lg` para comprobar el renderizado correcto con sintaxis de Static Noise.
3. Verificar que `git config --global --get-all include.path` contenga la referencia al archivo.
