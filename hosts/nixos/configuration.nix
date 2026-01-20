{ config, pkgs, noctalia, ... }:

let
  # Skift mellem "networkmanager" og "shared" (simpel DHCP)
  networkMode = "shared";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = (networkMode == "networkmanager");
  networking.useDHCP = (networkMode == "shared");

  # Timezone and locale
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # VMware guest support
  virtualisation.vmware.guest.enable = true;

  # Mount VMware shared folders
  fileSystems."/mnt/shared" = {
    device = ".host:/";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = [ "allow_other" "defaults" "uid=1000" "gid=100" ];
  };

  # Default: Niri compositor
  programs.niri.enable = true;

  # SDDM login manager med astronaut tema
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [ pkgs.sddm-astronaut ];
  };

  # Boot menu: terminal-only option
  specialisation.terminal.configuration = {
    system.nixos.tags = [ "terminal" ];
    programs.niri.enable = pkgs.lib.mkForce false;
    services.displayManager.sddm.enable = pkgs.lib.mkForce false;
    services.getty.autologinUser = "mathies";
  };

  # Keyboard - US layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  users.users.mathies = {
    isNormalUser = true;
    description = "mathies schou";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Enable zsh
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages
  environment.systemPackages = with pkgs; [
    git
    wget
    firefox
    ghostty
    nautilus

    # Rust development
    rustc
    cargo
    rustfmt
    rust-analyzer

    # Neovim dependencies
    ripgrep              # telescope live_grep og find_files
    lazygit              # lazygit.nvim

    # LSP servers
    lua-language-server  # lua_ls
    clang-tools          # clangd + clang-format
    typescript-language-server  # ts_ls
    vscode-langservers-extracted  # html, cssls, jsonls
    pyright              # python
    nil                  # nix (nil_ls)
    tinymist             # typst
    svelte-language-server  # svelte

    # Formatters
    stylua               # lua
    nodePackages.prettier  # js/ts/html/css/json/markdown/yaml
    black                # python
    isort                # python imports
    nixpkgs-fmt          # nix

    # Typst
    typst
    typstyle             # formatter
    zathura              # PDF viewer

    # Lua
    lua                  # lua runtime

    # Markdown
    marksman             # markdown LSP
  ] ++ [
    noctalia.packages.aarch64-linux.default
  ];

  system.stateVersion = "25.11";
}
