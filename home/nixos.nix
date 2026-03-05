{ config, pkgs, lib, hostName ? "nixos-dev", ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/ghostty.nix
    ./programs/zsh.nix
    ./programs/gtk.nix
  ];

  home = {
    username = "mathies";
    homeDirectory = lib.mkForce "/home/mathies";
    stateVersion = "24.05";

    packages = with pkgs; [
      # Fonts (for apps like Obsidian that need user-level font access)
      lilex
      nerd-fonts.lilex
      jetbrains-mono
      ia-writer-quattro
      ibm-plex
      atkinson-hyperlegible
      merriweather

      # Qt integration with GTK themes (for apps like Anki)
      libsForQt5.qtstyleplugins
      qt6.qtwayland

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

      # Archive manager
      file-roller

      # Remote access (Bachelor project, delete after)
      realvnc-vnc-viewer

    ];

    sessionVariables = {
      EDITOR = "nvim";
      # Qt theme integration for apps like Anki
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_STYLE_OVERRIDE = "gtk3";
      # Enable native Wayland support for Electron apps (fixes font issues in Obsidian)
      NIXOS_OZONE_WL = "1";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
      "$HOME/.claude/local"
    ];
  };

  # Link niri configuration (host-specific for ThinkPad P50)
  home.file.".config/niri".source =
    if hostName == "thinkpad-p50"
    then ../config/niri/hosts/thinkpad-p50
    else ../config/niri;

  # Link noctalia configuration (mkOutOfStoreSymlink so noctalia can write to it)
  home.file.".config/noctalia".source = config.lib.file.mkOutOfStoreSymlink "/home/mathies/dotfiles/config/noctalia";

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  # Cursor configuration
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  news.display = "silent";
}
