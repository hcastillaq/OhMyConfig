---
title: Preserve Zellij bindings and Fish aliases during theme migrations
date: 2026-09-09
category: logic-errors
module: configuration
problem_type: logic_error
component: zellij-and-fish
symptoms:
  - "Theme changes can remove established Zellij modal bindings or Fish shortcuts."
root_cause: config_error
resolution_type: config_change
severity: medium
tags: [static-noise, zellij, fish, theme-migration, behavior-preservation]
---

# Preserve Zellij bindings and Fish aliases during theme migrations

## Problem

A Static Noise migration changed shared terminal configuration files that also define user interaction. A visually correct result initially hid regressions in Zellij modal keymaps and Fish shortcuts.

## Symptoms

- Modal Zellij workflows can lose their declared actions or exits.
- Familiar Fish aliases, abbreviations, wrappers, PATH entries, or guarded tool initialization can disappear.
- Visual inspection alone still shows the intended palette.

## What Didn't Work

Treating `config/zellij/config.kdl` and `config/fish/config.fish` as theme-only files encouraged broad replacements around palette definitions. Those files also carry behavior: Zellij mode bindings and Fish shell commands and initialization.

Checking only rendered colors did not exercise mode transitions or command mappings.

## Solution

Keep the visual and behavioral contracts together, but edit them independently.

- Preserve Zellij's complete `keybinds clear-defaults=true` block in `config/zellij/config.kdl`. With defaults cleared, the declared `normal`, `pane`, `tab`, `resize`, `move`, `scroll`, `search`, `entersearch`, `renametab`, and `session` modes provide the active keymap. Keep each mode's explicit return to `Normal` where configured.
- Limit palette work to the `static-noise` theme tokens and presentation settings rather than replacing the keybind section.
- Keep Fish palette declarations separate from shell behavior in `config/fish/config.fish`: `cds` and `y`, aliases, directory abbreviations, PATH additions, and conditional initialization for installed tools.

## Why This Works

`clear-defaults=true` makes Zellij's local keybind declarations authoritative rather than cosmetic overrides. Fish color variables affect presentation, while aliases, functions, and initialization determine command and startup behavior. Preserving both categories keeps a palette migration behavior-preserving.

## Prevention

- Before editing a configuration file, inventory its presentation and behavior-bearing sections.
- Review the diff specifically for removed or changed `bind`, `alias`, `abbr`, `function`, PATH, and initialization lines.
- Load Fish with `fish -c "source config/fish/config.fish"` and resolve representative shortcuts.
- Parse Zellij configuration and exercise normal and modal entry/exit paths, especially when defaults are cleared.
- Treat a successful visual result as one verification signal, not proof that interaction behavior remains intact.

## Related Issues

- None recorded.
