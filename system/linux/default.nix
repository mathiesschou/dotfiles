# Linux system configuration
#
# For CachyOS (Arch-based): Use home-manager standalone
# For NixOS: This can be extended with NixOS modules
#
# CachyOS setup:
#   1. Install Nix: sh <(curl -L https://nixos.org/nix/install) --daemon
#   2. Enable flakes: mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
#   3. Run: nix run home-manager -- switch --flake ~/dotfiles#mathies-linux

{ pkgs, ... }:

{
  # System packages for Linux
  # On CachyOS, install these with pacman instead:
  #   sudo pacman -S neovim git ripgrep fd lazygit fzf

  environment.systemPackages = with pkgs; [
    neovim
    git
    tree
    ripgrep
    fd
    gcc
    nodejs_20
    lazygit
    fzf
    tree-sitter
    nil
    nixpkgs-fmt
    clang

    # Rust
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];
}
