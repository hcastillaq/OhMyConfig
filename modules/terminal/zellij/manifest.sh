# Zellij multiplexer manifest
MODULE_NAME="Zellij"
MODULE_DESC="Modern terminal multiplexer with Static Noise palette"
MODULE_TARGETS=(
    "config.kdl:zellij/config.kdl"
    "@static-noise/zellij/static-noise.kdl:zellij/themes/static-noise.kdl"
    "@static-noise/zellij/layouts/default.kdl:zellij/layouts/default.kdl"
    "plugins/zjstatus.wasm:zellij/plugins/zjstatus.wasm"
)
