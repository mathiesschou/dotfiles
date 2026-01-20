{ config, pkgs, noctalia, ... }:

let
  # SDDM tema uden blur
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
  networking.hostName = "nixos-vm";
  networking.networkmanager = {
    enable = true;
    insertNameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

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


  # Default: Niri compositor
  programs.niri.enable = true;

  # SDDM login manager med astronaut tema (ingen blur)
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
    sddm-astronaut-noblur

    # VMware shared folder mount script
    (writeShellScriptBin "mount-shared" ''
      sudo mkdir -p /mnt/shared
      sudo vmhgfs-fuse -o allow_other,uid=1000,gid=100 .host:/ /mnt/shared
      echo "Mounted VMware shared folders at /mnt/shared"
    '')

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

    # For AI tools
    nodejs_20
    python3
    python3Packages.pip
  ] ++ [
    noctalia.packages.aarch64-linux.default
  ];

  # Systemd service til at installere AI tools efter netværk er oppe
  systemd.services.setup-ai-tools = {
    description = "Install Claude and Codex CLI tools";
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
        npm install -g @anthropic-ai/claude-code || true
        npm install -g @openai/codex || true
        npm install -g context7 || true
        touch "$MARKER_FILE"
      fi

      # Setup MCP servers for Claude
      CLAUDE_MARKER="$HOME/.claude-mcp-setup-done"
      if [ ! -f "$CLAUDE_MARKER" ]; then
        $HOME/.npm-global/bin/claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server || true
        $HOME/.npm-global/bin/claude mcp add --scope user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true
        $HOME/.npm-global/bin/claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp || true
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
