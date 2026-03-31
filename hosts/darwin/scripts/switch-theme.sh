#!/usr/bin/env bash
# Switch macOS theme between light (latte) and dark (mocha)

set -euo pipefail

# Determine theme variant
if [ $# -eq 0 ]; then
    # No argument - read from theme file
    THEME_FILE="$HOME/.config/theme-variant"
    if [ -f "$THEME_FILE" ]; then
        VARIANT=$(cat "$THEME_FILE")
    else
        VARIANT="mocha"  # Default to dark
    fi
else
    VARIANT="$1"
fi

# Normalize variant (light/dark aliases)
case "$VARIANT" in
    light|latte|false|0)
        VARIANT="latte"
        ;;
    dark|mocha|true|1)
        VARIANT="mocha"
        ;;
    frappe|frappé)
        VARIANT="frappe"
        ;;
    *)
        echo "Error: Unknown variant '$VARIANT'"
        echo "Valid variants: latte, mocha, frappe, light, dark"
        exit 1
        ;;
esac

echo "Switching to Catppuccin $VARIANT..."

# Update theme variant file
mkdir -p "$HOME/.config"
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
        ;;
    mocha)
        GHOSTTY_THEME="catppuccin-mocha"
        TMUX_THEME="theme-dark.conf"
        ;;
    frappe)
        GHOSTTY_THEME="catppuccin-frappe"
        TMUX_THEME="theme-frappe.conf"
        ;;
esac

# Switch Ghostty theme (macOS path)
GHOSTTY_CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config"

if [ -f "$GHOSTTY_CONFIG" ] || [ -L "$GHOSTTY_CONFIG" ]; then
    # For Nix-managed configs, edit the source file in dotfiles instead of the symlink
    EDIT_TARGET=""

    if [ -L "$GHOSTTY_CONFIG" ]; then
        # Fully resolve the symlink to find the source
        if command -v realpath &> /dev/null; then
            RESOLVED=$(realpath "$GHOSTTY_CONFIG")
        elif command -v greadlink &> /dev/null; then
            RESOLVED=$(greadlink -f "$GHOSTTY_CONFIG")
        else
            # Fallback: manually resolve symlink
            RESOLVED="$GHOSTTY_CONFIG"
            while [ -L "$RESOLVED" ]; do
                RESOLVED=$(readlink "$RESOLVED")
                # Handle relative symlinks
                if [[ "$RESOLVED" != /* ]]; then
                    RESOLVED="$(dirname "$GHOSTTY_CONFIG")/$RESOLVED"
                fi
            done
        fi

        # Check if the resolved path is writable
        if [ -w "$RESOLVED" ]; then
            EDIT_TARGET="$RESOLVED"
        else
            # Try dotfiles as fallback
            DOTFILES_CONFIG="$HOME/dotfiles/config/ghostty/config"
            if [ -f "$DOTFILES_CONFIG" ] && [ -w "$DOTFILES_CONFIG" ]; then
                EDIT_TARGET="$DOTFILES_CONFIG"
                echo "Using dotfiles source: $EDIT_TARGET"
            else
                echo "Error: Cannot edit Ghostty config (no writable source found)"
            fi
        fi
    else
        # Not a symlink, use it directly if writable
        if [ -w "$GHOSTTY_CONFIG" ]; then
            EDIT_TARGET="$GHOSTTY_CONFIG"
        fi
    fi

    if [ -n "$EDIT_TARGET" ]; then
        # macOS requires backup extension for sed -i
        sed -i '' "s|^theme = .*|theme = \"$GHOSTTY_THEME\"|" "$EDIT_TARGET"
        echo "Updated Ghostty theme in: $EDIT_TARGET"
    fi
fi

# Switch tmux theme
TMUX_DIR="$HOME/dotfiles/config/tmux"
TMUX_LINK="$HOME/.config/tmux/theme.conf"
mkdir -p "$(dirname "$TMUX_LINK")"
ln -sf "$TMUX_DIR/$TMUX_THEME" "$TMUX_LINK"

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

echo "Theme switched to Catppuccin $VARIANT!"
