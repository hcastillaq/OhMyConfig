# Pi Coding Agent manifest
MODULE_NAME="Pi"
MODULE_DESC="Pi Coding Agent configurations, themes, and extensions"
MODULE_TARGETS=(
    "@static-noise/pi/static-noise-theme.json:pi/themes/static-noise.json"
    "extensions/ohmyconfig-header.ts:pi/extensions/ohmyconfig-header.ts"
    "extensions/model-policy:pi/extensions/model-policy"
)
