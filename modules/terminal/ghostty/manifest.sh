# Ghostty terminal emulator manifest
MODULE_NAME="Ghostty"
MODULE_DESC="Fast, GPU-accelerated terminal emulator"
MODULE_TARGETS=(
    "config:ghostty/config"
    "@static-noise/ghostty/static-noise:ghostty/themes/static-noise"
)
