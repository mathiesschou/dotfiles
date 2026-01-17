#!/bin/bash
# CachyOS Bootstrap Script
# Run this on a fresh CachyOS install to set up development environment
#
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USER/dotfiles/main/system/linux/bootstrap.sh | bash

set -e

echo "=== CachyOS Development Environment Bootstrap ==="

# TODO: Add your packages here
# sudo pacman -S --needed \
#   base-devel git curl wget \
#   fish ghostty neovim \
#   ripgrep fd fzf lazygit \
#   nodejs npm rustup

# TODO: Install Nix
# sh <(curl -L https://nixos.org/nix/install) --daemon

# TODO: Enable flakes
# mkdir -p ~/.config/nix
# echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# TODO: Clone dotfiles and run home-manager
# git clone https://github.com/YOUR_USER/dotfiles ~/dotfiles
# nix run home-manager -- switch --flake ~/dotfiles#mathies-linux

echo "=== Bootstrap complete ==="
