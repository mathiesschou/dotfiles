{ config, pkgs, noctalia, ... }:

let
  sddm-astronaut-noblur = pkgs.sddm-astronaut.override {
    themeConfig = {
      FullBlur = "false";
      PartialBlur = "false";
      BlurRadius = "0";
    };
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "thinkpad-p50";
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

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

  # NVIDIA Quadro M2200 (ThinkPad P50)
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # Docker
  virtualisation.docker.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "mathies";
    dataDir = "/home/mathies";
    configDir = "/home/mathies/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
  };

  # Hardware acceleration
  hardware.graphics.enable = true;

  # Firefox/Wayland environment
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };

  # Firefox med smooth scrolling
  programs.firefox = {
    enable = true;
    preferences = {
      "gfx.webrender.all" = true;
      "widget.wayland-vsync.enabled" = true;
    };
  };

  # Window managers / compositors
  programs.niri.enable = true;

  # SDDM login manager w. astronaut theme (no blur)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [ sddm-astronaut-noblur ];
    settings = {
      General = {
        GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=1";
      };
    };
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "mathies";
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
    extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
    shell = pkgs.zsh;
    initialPassword = "sofus";
  };

  # Enable zsh
  programs.zsh.enable = true;

  # Allow dynamically linked binaries
  programs.nix-ld.enable = true;

  # Allow unfree packages (required for NVIDIA)
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages
  environment.systemPackages = with pkgs; [
    git
    gh
    wget
    dnsutils
    ghostty
    nautilus
    sddm-astronaut-noblur

    # Rust development
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    rustPlatform.rustLibSrc
    gcc

    # Neovim dependencies
    ripgrep
    lazygit

    # LSP servers
    lua-language-server
    clang-tools
    typescript-language-server
    vscode-langservers-extracted
    pyright
    nil
    tinymist
    svelte-language-server

    # Formatters
    stylua
    nodePackages.prettier
    black
    isort
    nixpkgs-fmt

    # Typst
    typst
    typstyle
    zathura
    websocat

    # Lua
    lua

    # Markdown
    marksman

    # .NET Development
    dotnet-sdk_9
    csharp-ls

    # AI tools
    claude-code
    nodejs_20
    python3
    python3Packages.pip
  ] ++ [
    noctalia.packages.x86_64-linux.default
  ];

  # Systemd service for AI CLI tools
  systemd.services.setup-ai-tools = {
    description = "Install Codex CLI tool and setup MCP servers";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "mathies";
      RemainAfterExit = true;
    };
    path = [ pkgs.nodejs_20 pkgs.git pkgs.bash pkgs.python3 ];
    script = ''
      export HOME=/home/mathies
      export PATH="${pkgs.nodejs_20}/bin:$HOME/.npm-global/bin:$PATH"
      mkdir -p $HOME/.npm-global
      echo "prefix=$HOME/.npm-global" > $HOME/.npmrc

      MARKER_FILE="$HOME/.ai-tools-setup-done"
      if [ ! -f "$MARKER_FILE" ]; then
        npm install -g @openai/codex || true
        npm install -g context7 || true
        touch "$MARKER_FILE"
      fi

      CLAUDE_MARKER="$HOME/.claude-mcp-setup-done"
      if [ ! -f "$CLAUDE_MARKER" ]; then
        claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server || true
        claude mcp add --scope user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true
        claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp || true
        touch "$CLAUDE_MARKER"
      fi

      CODEX_MARKER="$HOME/.codex-mcp-setup-done"
      if [ ! -f "$CODEX_MARKER" ]; then
        $HOME/.npm-global/bin/codex mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server || true
        $HOME/.npm-global/bin/codex mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true
        $HOME/.npm-global/bin/codex mcp add context7 -- npx -y @upstash/context7-mcp || true
        touch "$CODEX_MARKER"
      fi
    '';
  };

  system.stateVersion = "25.11";
}
