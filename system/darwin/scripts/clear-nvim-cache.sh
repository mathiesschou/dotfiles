#!/bin/bash
# Clear Neovim lazy.nvim cache to ensure fresh plugin configuration

NVIM_SHARE="$HOME/.local/share/nvim"
NVIM_STATE="$HOME/.local/state/nvim"
NVIM_CACHE="$HOME/.cache/nvim"

echo "Clearing Neovim lazy.nvim cache..."

# Remove lazy.nvim directories
rm -rf "$NVIM_SHARE/lazy" 2>/dev/null
rm -rf "$NVIM_STATE/lazy" 2>/dev/null
rm -rf "$NVIM_CACHE" 2>/dev/null

echo "Neovim cache cleared (lazy.nvim will reinstall plugins on next launch)"
