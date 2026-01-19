#!/bin/bash
# Set a random wallpaper from the dotfiles wallpapers directory

WALLPAPER_DIR="$HOME/dotfiles/wallpapers"

if [[ -d "$WALLPAPER_DIR" ]]; then
    # Get a random wallpaper
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

    if [[ -n "$WALLPAPER" ]]; then
        echo "Setting wallpaper: $(basename "$WALLPAPER")"
        /usr/bin/osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
        echo "Wallpaper set successfully"
    else
        echo "No wallpapers found in $WALLPAPER_DIR"
    fi
else
    echo "Wallpaper directory not found: $WALLPAPER_DIR"
fi
