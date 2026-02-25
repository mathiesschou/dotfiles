{ config, pkgs, lib, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/ghostty.nix
    ./programs/zsh.nix
  ];

  home = {
    username = "mathies";
    homeDirectory = lib.mkForce "/home/mathies";
    stateVersion = "24.05";

    packages = with pkgs; [
      # Fonts
      nerd-fonts.jetbrains-mono

      # Language servers
      clang-tools
      lua-language-server
      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
      nodePackages.vscode-langservers-extracted
      pyright
      tinymist
      typst

      # Formatters
      nodePackages.prettier

      # Dev tools
      pnpm
      direnv

      # Niri utilities
      waybar
      fuzzel
      mako
      wl-clipboard
      swaylock
      swaybg
      grim
      slurp

    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
      "$HOME/.claude/local"
    ];
  };

  # Link niri configuration
  home.file.".config/niri".source = ../config/niri;

  # Link noctalia configuration (mkOutOfStoreSymlink so noctalia can write to it)
  home.file.".config/noctalia".source = config.lib.file.mkOutOfStoreSymlink "/home/mathies/dotfiles/config/noctalia";

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  news.display = "silent";
}
