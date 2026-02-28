#!/usr/bin/env bash
# Theme picker - shows fuzzel menu to select Catppuccin variant
# Supports: latte (light), mocha (dark), frappe, macchiato

set -euo pipefail

# Check if fuzzel is available
if ! command -v fuzzel &> /dev/null; then
    echo "Error: fuzzel is required but not installed"
    exit 1
fi

# Get current theme
THEME_FILE="$HOME/.config/theme-variant"
if [ -f "$THEME_FILE" ]; then
    CURRENT_THEME=$(cat "$THEME_FILE")
else
    CURRENT_THEME="mocha"
fi

# Create menu options with current theme marked
OPTIONS=""
[ "$CURRENT_THEME" = "latte" ] && MARKER=" ●" || MARKER=""
OPTIONS+="Catppuccin Latte (Light)$MARKER"$'\n'
[ "$CURRENT_THEME" = "mocha" ] && MARKER=" ●" || MARKER=""
OPTIONS+="Catppuccin Mocha (Dark)$MARKER"$'\n'
[ "$CURRENT_THEME" = "frappe" ] && MARKER=" ●" || MARKER=""
OPTIONS+="Catppuccin Frappé$MARKER"$'\n'
[ "$CURRENT_THEME" = "macchiato" ] && MARKER=" ●" || MARKER=""
OPTIONS+="Catppuccin Macchiato$MARKER"

# Show fuzzel menu
SELECTED=$(echo "$OPTIONS" | fuzzel --dmenu --prompt "Theme: " --lines 4 --width 40)

# Map selection to variant (strip the marker if present)
SELECTED_CLEAN="${SELECTED% ●}"
case "$SELECTED_CLEAN" in
    "Catppuccin Latte (Light)")
        VARIANT="latte"
        ;;
    "Catppuccin Mocha (Dark)")
        VARIANT="mocha"
        ;;
    "Catppuccin Frappé")
        VARIANT="frappe"
        ;;
    "Catppuccin Macchiato")
        VARIANT="macchiato"
        ;;
    *)
        echo "No theme selected or cancelled"
        exit 0
        ;;
esac

# Switch to selected theme
"$HOME/dotfiles/scripts/switch-theme.sh" "$VARIANT"
