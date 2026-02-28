#!/usr/bin/env bash
# Toggle between light and dark mode
# Updates Noctalia settings and triggers theme switch

set -euo pipefail

NOCTALIA_SETTINGS="$HOME/.config/noctalia/settings.json"

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    exit 1
fi

# Read current dark mode state from Noctalia
if [ -f "$NOCTALIA_SETTINGS" ]; then
    CURRENT_MODE=$(jq -r '.colorSchemes.darkMode' "$NOCTALIA_SETTINGS")

    # Toggle the mode
    if [ "$CURRENT_MODE" = "true" ]; then
        NEW_MODE="false"
        THEME="light"
    else
        NEW_MODE="true"
        THEME="dark"
    fi

    # Update Noctalia settings
    jq ".colorSchemes.darkMode = $NEW_MODE" "$NOCTALIA_SETTINGS" > "$NOCTALIA_SETTINGS.tmp"
    mv "$NOCTALIA_SETTINGS.tmp" "$NOCTALIA_SETTINGS"

    # Run theme switcher
    "$HOME/dotfiles/scripts/switch-theme.sh" "$THEME"

    echo "Toggled to $THEME mode"
else
    echo "Error: Noctalia settings not found"
    exit 1
fi
