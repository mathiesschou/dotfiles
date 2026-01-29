#!/bin/sh
WALLPAPER=$(find ~/dotfiles/wallpapers -type f | shuf -n 1)
exec swaybg -m fill -i "$WALLPAPER"
