{ config, pkgs, ... }:

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
    homeDirectory = "/home/mathies";
    stateVersion = "24.05";

    packages = with pkgs; [
      zsh-powerlevel10k

      # Language servers
      clang-tools
      lua-language-server
      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
      nodePackages.vscode-langservers-extracted
      pyright
      texlab
      texlive.combined.scheme-medium
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
    ];
  };

  # Link niri configuration
  home.file.".config/niri".source = ../niri/.config/niri;

  # Symlink to shared folder
  home.file."shared".source = config.lib.file.mkOutOfStoreSymlink "/mnt/shared";

  programs.home-manager.enable = true;

  news.display = "silent";
}
