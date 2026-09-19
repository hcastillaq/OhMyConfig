# Zellij multiplexer manifest
MODULE_NAME="Zellij"
MODULE_DESC="Modern terminal multiplexer with Static Noise palette"
MODULE_TARGETS=(
    "config.kdl:zellij/config.kdl"
    "themes/static-noise.kdl:zellij/themes/static-noise.kdl"
    "layouts/default.kdl:zellij/layouts/default.kdl"
    "plugins/zjstatus.wasm:zellij/plugins/zjstatus.wasm"
)
