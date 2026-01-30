{ config, pkgs, noctalia, ... }:

let
  # SDDM theme w. no blur 
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
    /etc/nixos/hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos-dev";
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

  # VMware guest support
  virtualisation.vmware.guest.enable = true;

  # Docker
  virtualisation.docker.enable = true;

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

  # VMware shared folder mount service (not auto-started)
  systemd.services.mount-vmware-shared = {
    description = "Mount VMware shared folders";
    after = [ "vmware-vmblock-fuse.service" ];
    # Must be enabled manually with: enable-shared-mount
    # For quicker setup. 
    path = [ pkgs.coreutils pkgs.open-vm-tools pkgs.util-linux pkgs.fuse ];
    script = ''
      # Clean up stale mount if exists
      if mountpoint -q /mnt/shared 2>/dev/null || [ -d /mnt/shared ]; then
        umount -l /mnt/shared 2>/dev/null || fusermount -uz /mnt/shared 2>/dev/null || true
      fi
      mkdir -p /mnt/shared
      USER_UID=$(id -u mathies)
      USER_GID=$(id -g mathies)
      vmhgfs-fuse -o allow_other,uid=$USER_UID,gid=$USER_GID .host:/ /mnt/shared
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.util-linux}/bin/umount /mnt/shared";
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
        GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2";
      };
    };
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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Enable zsh
  programs.zsh.enable = true;

  # Allow dynamically linked binaries
  programs.nix-ld.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages
  environment.systemPackages = with pkgs; [
    git
    gh
    wget
    dnsutils # nslookup, dig, host
    ghostty
    nautilus
    sddm-astronaut-noblur

    # Run once after first flake to enable persistent mounting
    (writeShellScriptBin "enable-shared-mount" ''
      sudo systemctl enable mount-vmware-shared.service
      sudo systemctl start mount-vmware-shared.service
      ln -sfn /mnt/shared/mathies/projects ~/projects
      echo "Shared folder mounting is now persistent across reboots"
      echo "Created ~/projects symlink"
    '')

    # Rust development
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    rustPlatform.rustLibSrc # rust-src for rust-analyzer stdlib navigation
    gcc # C linker required by rustc

    # Neovim dependencies
    ripgrep # telescope live_grep og find_files
    lazygit # lazygit.nvim

    # LSP servers
    lua-language-server # lua_ls
    clang-tools # clangd + clang-format
    typescript-language-server # ts_ls
    vscode-langservers-extracted # html, cssls, jsonls
    pyright # python
    nil # nix (nil_ls)
    tinymist # typst
    svelte-language-server # svelte

    # Formatters
    stylua # lua
    nodePackages.prettier # js/ts/html/css/json/markdown/yaml
    black # python
    isort # python imports
    nixpkgs-fmt # nix

    # Typst
    typst
    typstyle # formatter
    zathura # PDF viewer

    # Lua
    lua # lua runtime

    # Markdown
    marksman # markdown LSP

    # .NET Development
    dotnet-sdk_9 # .NET 9 SDK (includes runtime, backwards compatible with .NET 8 projects)
    # for backend course.
    csharp-ls # C# language server for Neovim

    # AI tools
    claude-code
    nodejs_20
    python3
    python3Packages.pip
  ] ++ [
    noctalia.packages.aarch64-linux.default
  ];

  # Systemd service for install og ai cli's in terminal.
  # after network is up. 
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

      # Setup MCP servers for Claude (native install)
      CLAUDE_MARKER="$HOME/.claude-mcp-setup-done"
      if [ ! -f "$CLAUDE_MARKER" ]; then
        claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server || true
        claude mcp add --scope user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true
        claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp || true
        touch "$CLAUDE_MARKER"
      fi

      # Setup MCP servers for Codex
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
