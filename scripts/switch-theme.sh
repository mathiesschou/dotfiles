#!/usr/bin/env bash
# Switch system theme between Catppuccin variants
# Supports: latte (light), mocha (dark), frappe, macchiato

set -euo pipefail

# Determine theme variant
if [ $# -eq 0 ]; then
    # Called from Noctalia hook - check Noctalia's dark mode setting
    NOCTALIA_SETTINGS="$HOME/.config/noctalia/settings.json"
    THEME_FILE="$HOME/.config/theme-variant"

    if [ -f "$NOCTALIA_SETTINGS" ] && command -v jq &> /dev/null; then
        # Read current dark mode from Noctalia
        DARK_MODE=$(jq -r '.colorSchemes.darkMode' "$NOCTALIA_SETTINGS")

        # Read current theme variant
        if [ -f "$THEME_FILE" ]; then
            CURRENT_VARIANT=$(cat "$THEME_FILE")
        else
            CURRENT_VARIANT="mocha"
        fi

        # Decide which theme to use based on dark mode and current variant
        if [ "$DARK_MODE" = "true" ]; then
            # Dark mode is on
            if [ "$CURRENT_VARIANT" = "latte" ]; then
                # Switch from light to dark (use mocha as default)
                VARIANT="mocha"
            else
                # Already a dark theme, keep it
                VARIANT="$CURRENT_VARIANT"
            fi
        else
            # Dark mode is off
            if [ "$CURRENT_VARIANT" = "latte" ]; then
                # Already light, keep it
                VARIANT="latte"
            else
                # Switch from dark to light
                VARIANT="latte"
            fi
        fi
    else
        # Fallback to reading from theme file
        if [ -f "$THEME_FILE" ]; then
            VARIANT=$(cat "$THEME_FILE")
        else
            VARIANT="mocha"
        fi
    fi
else
    VARIANT="$1"
fi

# Normalize variant (handle aliases and boolean values)
case "$VARIANT" in
    light|latte|false|0)
        VARIANT="latte"
        ;;
    dark|mocha|true|1)
        VARIANT="mocha"
        ;;
    frappe|macchiato)
        # Keep as-is
        ;;
    *)
        echo "Error: Unknown variant '$VARIANT'"
        echo "Valid variants: latte, mocha, frappe, macchiato, light, dark"
        exit 1
        ;;
esac

echo "Switching to Catppuccin $VARIANT..."

# Update theme variant file
echo "$VARIANT" > "$HOME/.config/theme-variant"

# Update theme mode file (for nvim)
if [ "$VARIANT" = "latte" ]; then
    echo "light" > "$HOME/.config/theme-mode"
else
    echo "dark" > "$HOME/.config/theme-mode"
fi

# Map variant to settings
case "$VARIANT" in
    latte)
        GHOSTTY_THEME="catppuccin-latte"
        TMUX_THEME="theme-light.conf"
        GTK_THEME="catppuccin-latte-blue-standard+default"
        GTK_PREFER_DARK="false"
        COLOR_SCHEME=2  # 1=dark, 2=light
        DARK_MODE="false"
        ;;
    mocha)
        GHOSTTY_THEME="catppuccin-mocha"
        TMUX_THEME="theme-dark.conf"
        GTK_THEME="catppuccin-mocha-blue-standard+default"
        GTK_PREFER_DARK="true"
        COLOR_SCHEME=1
        DARK_MODE="true"
        ;;
    frappe)
        GHOSTTY_THEME="catppuccin-frappe"
        TMUX_THEME="theme-frappe.conf"
        GTK_THEME="catppuccin-frappe-blue-standard+default"
        GTK_PREFER_DARK="true"
        COLOR_SCHEME=1
        DARK_MODE="true"
        ;;
    macchiato)
        GHOSTTY_THEME="catppuccin-macchiato"
        TMUX_THEME="theme-macchiato.conf"
        GTK_THEME="catppuccin-macchiato-blue-standard+default"
        GTK_PREFER_DARK="true"
        COLOR_SCHEME=1
        DARK_MODE="true"
        ;;
esac

# Switch Ghostty theme
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
if [ -f "$GHOSTTY_CONFIG" ]; then
    sed -i "s|^theme = .*|theme = \"$GHOSTTY_THEME\"|" "$GHOSTTY_CONFIG"
fi

# Switch tmux theme
TMUX_DIR="$HOME/dotfiles/config/tmux"
TMUX_LINK="$HOME/.config/tmux/theme.conf"
mkdir -p "$(dirname "$TMUX_LINK")"
ln -sf "$TMUX_DIR/$TMUX_THEME" "$TMUX_LINK"

# Update Noctalia settings (do this early to avoid issues if later steps fail)
NOCTALIA_SETTINGS="$HOME/.config/noctalia/settings.json"
if [ -f "$NOCTALIA_SETTINGS" ] && command -v jq &> /dev/null; then
    jq --indent 4 ".colorSchemes.darkMode = $DARK_MODE" "$NOCTALIA_SETTINGS" > "$NOCTALIA_SETTINGS.tmp" && \
        mv "$NOCTALIA_SETTINGS.tmp" "$NOCTALIA_SETTINGS"
fi

# Update GTK theme settings using dconf (works on NixOS with home-manager)
if command -v dconf &> /dev/null; then
    dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'"

    # Set color-scheme (for Electron apps like Obsidian, Anki)
    if [ "$GTK_PREFER_DARK" = "true" ]; then
        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        dconf write /org/gnome/desktop/interface/gtk-application-prefer-dark-theme true
    else
        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        dconf write /org/gnome/desktop/interface/gtk-application-prefer-dark-theme false
    fi
fi

# Also set GTK_THEME environment variable for new apps
export GTK_THEME="$GTK_THEME"

# Update D-Bus color-scheme portal (for apps like Obsidian, Zen Browser)
if command -v dbus-send &> /dev/null; then
    dbus-send --session \
        --dest=org.freedesktop.portal.Desktop \
        --type=method_call \
        /org/freedesktop/portal/desktop \
        org.freedesktop.portal.Settings.Write \
        string:'org.freedesktop.appearance' \
        string:'color-scheme' \
        variant:uint32:$COLOR_SCHEME 2>/dev/null || true
fi

# Reload all tmux sessions
if command -v tmux &> /dev/null; then
    if tmux list-sessions &>/dev/null 2>&1; then
        tmux list-sessions -F '#S' 2>/dev/null | while read -r session; do
            tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true
        done
    fi
fi

# Ghostty auto-reloads config, so no need to send signals

# Reload Neovim instances
pkill -USR1 nvim 2>/dev/null || true

# Quit GTK file managers to pick up new theme on next launch
if pgrep -x nautilus > /dev/null; then
    nautilus -q 2>/dev/null || true
fi

# Notify user
echo "Theme switched to Catppuccin $VARIANT!"
echo "Electron apps (Obsidian, Anki) need to be restarted to pick up the new theme."
