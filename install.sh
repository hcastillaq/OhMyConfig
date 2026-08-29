#!/usr/bin/env bash
# install.sh — Wrapper de compatibilidad con el flujo anterior.
# El instalador real es ./omc — este script lo invoca con --all --link.
exec "$(dirname "$0")/omc" install --all --link "$@"
