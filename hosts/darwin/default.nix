{ pkgs, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  # system-wide packages
  environment.systemPackages = with pkgs; [
    neovim
    git
    tree
    ripgrep
    fd
    gcc
    clang
    lazygit
    fzf
    tree-sitter
    nil
    nixpkgs-fmt
    nodejs_20 # mcp servers
    claude-code # antrophic cli
    postgresql #database
    typst # typst
    tinymist # typst related tools
    websocat # typst related tools
  ];

  nixpkgs.config.allowUnfree = true; # proprietary software allow
  nixpkgs.config.allowUnsupportedSystem = true; # packages not tested on ARM
  nix.enable = false; # disable managing nix daemon, as it is already installed 

  # Apple's API dependencides for compiling some packages.  
  nixpkgs.config.darwin.apple_sdk.frameworks = [
    "Security"
    "CoreFoundation"
    "Foundation"
    "Iconv"
  ];

  # set environment variables
  environment.variables = {
    CC = "${pkgs.clang}/bin/clang";
    CXX = "${pkgs.clang}/bin/clang++";
  };

  # system defaults
  system.defaults = {
    NSGlobalDomain = {
      _HIHideMenuBar = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 20;
      "com.apple.trackpad.scaling" = 1.5;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      NewWindowTarget = "Home";
    };

    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
      mru-spaces = false;

      # apps in dock
      persistent-apps = [
        "/Applications/Ghostty.app"
        "/Applications/Zen.app"
      ];

      persistent-others = [
        "/Users/mathies/Downloads"
      ];
    };
  };

  # allow unstable nix-features  
  nix.settings.experimental-features = "nix-command flakes";

  # use zsh from nix packages as main zsh
  programs.zsh.enable = true;

  # System version
  system.stateVersion = 5;
  system.primaryUser = "mathies";
  networking.computerName = "mathies-macos";
  networking.hostName = "mathies-macos";
  networking.localHostName = "mathies-macos";

  # keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # settings scripts that nixos cannot control 
  system.activationScripts.extraActivation.text = ''
    echo "use input source US and DK"
    /usr/bin/sudo -u mathies /bin/bash -c '
      # Add English (US) input source
      /usr/bin/defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
        "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0</integer><key>KeyboardLayout Name</key><string>U.S.</string></dict>" \
        "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>9</integer><key>KeyboardLayout Name</key><string>Danish</string></dict>"
    ' || true

    echo "ctrl+space to alternate input sourcess"
    /usr/bin/sudo -u mathies /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>" || true
    /usr/bin/sudo -u mathies /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>786432</integer></array><key>type</key><string>standard</string></dict></dict>" || true

    echo "fn key for emojis"
    /usr/bin/sudo -u mathies /usr/bin/defaults write com.apple.HIToolbox AppleFnUsageType -int 2

    # Apply settings immediately
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    # install rosetts if not installed
    if [[ $(uname -m) == "arm64" ]] && ! /usr/bin/pgrep -q oahd; then
      echo "Installing Rosetta 2"
      /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    fi


    echo "set ghostty as default terminal"
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./scripts/set-default-terminal.sh}

    echo "check if ssh is present, create if not"
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./scripts/setup-ssh.sh}

    # Remove quarantine from f.lux and ensure it's in Login Items
    if [[ -d "/Applications/Flux.app" ]]; then
      echo "Removing quarantine from f.lux"
      /usr/bin/xattr -cr /Applications/Flux.app 2>/dev/null || true

      # Add f.lux to Login Items if not already there
      /usr/bin/sudo -u mathies /usr/bin/osascript -e 'tell application "System Events" to delete login item "Flux"' &>/dev/null || true
      /usr/bin/sudo -u mathies /usr/bin/osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Flux.app", hidden:false}' &>/dev/null || true
      echo "f.lux added to Login Items"
    fi

    echo "setting wallpaper"
    /usr/bin/sudo -u mathies /usr/bin/osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"/Users/mathies/dotfiles/wallpapers/airballons.jpg\""

    # Install Codex and setup MCP servers
    # Note: Requires Node.js to be available (install via project flake or globally if needed)
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash -c '
      # Setup npm global directory
      mkdir -p $HOME/.npm-global
      mkdir -p $HOME/.npm-global/lib

      # Configure npm
      echo "prefix=$HOME/.npm-global" > $HOME/.npmrc

      # Ensure config directories exist
      mkdir -p $HOME/.config/claude
      mkdir -p $HOME/.config/codex

      MARKER="$HOME/.ai-tools-setup-done"
      if [ ! -f "$MARKER" ]; then
        echo "Installing Codex..."

        # Use npm from PATH (requires Node.js to be available)
        if command -v npm >/dev/null 2>&1 && npm install -g @openai/codex 2>&1; then
          echo "codex installed successfully"
          touch "$MARKER"
        else
          echo "codex installation failed"
          echo "you may need to run: npm install -g @openai/codex"
        fi
      fi

      CLAUDE_MARKER="$HOME/.claude-mcp-setup-done"
      if [ ! -f "$CLAUDE_MARKER" ]; then
        echo "setting up Claude MCP servers..."

        # Add serena
        OUTPUT=$(${pkgs.claude-code}/bin/claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server 2>&1)
        if echo "$OUTPUT" | grep -q "already exists"; then
          echo "claude: serena (already configured)"
        elif [ $? -eq 0 ]; then
          echo "claude: serena added"
        else
          echo "claude: serena failed"
        fi

        # Add sequential-thinking
        OUTPUT=$(${pkgs.claude-code}/bin/claude mcp add --scope user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking 2>&1)
        if echo "$OUTPUT" | grep -q "already exists"; then
          echo "claude: sequential-thinking (already configured)"
        elif [ $? -eq 0 ]; then
          echo "claude: sequential-thinking added"
        else
          echo "claude: sequential-thinking failed"
        fi

        # Add context7
        OUTPUT=$(${pkgs.claude-code}/bin/claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp 2>&1)
        if echo "$OUTPUT" | grep -q "already exists"; then
          echo "claude: context7 (already configured)"
        elif [ $? -eq 0 ]; then
          echo "claude: context7 added"
        else
          echo "claude: context7 failed"
        fi

        touch "$CLAUDE_MARKER"
      fi

      CODEX_MARKER="$HOME/.codex-mcp-setup-done"
      if [ ! -f "$CODEX_MARKER" ]; then
        echo "setting up Codex MCP servers..."

        if [ ! -f "$HOME/.npm-global/bin/codex" ]; then
          echo "codex not found at $HOME/.npm-global/bin/codex, skipping MCP setup"
        else
          # Add serena
          OUTPUT=$($HOME/.npm-global/bin/codex mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server 2>&1)
          if echo "$OUTPUT" | grep -q "already exists"; then
            echo "codex: serena (already configured)"
          elif echo "$OUTPUT" | grep -q "Added"; then
            echo "codex: serena added"
          else
            echo "codex: serena failed"
          fi

          # Add sequential-thinking
          OUTPUT=$($HOME/.npm-global/bin/codex mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking 2>&1)
          if echo "$OUTPUT" | grep -q "already exists"; then
            echo "codex: sequential-thinking (already configured)"
          elif echo "$OUTPUT" | grep -q "Added"; then
            echo "codex: sequential-thinking added"
          else
            echo "codex: sequential-thinking failed"
          fi

          # Add context7
          OUTPUT=$($HOME/.npm-global/bin/codex mcp add context7 -- npx -y @upstash/context7-mcp 2>&1)
          if echo "$OUTPUT" | grep -q "already exists"; then
            echo "codex: context7 (already configured)"
          elif echo "$OUTPUT" | grep -q "Added"; then
            echo "codex: context7 added"
          else
            echo "codex: context7 failed"
          fi
        fi

        touch "$CODEX_MARKER"
      fi
    ' || true
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.mathies = {
    name = "mathies";
    home = "/Users/mathies";
  };
}
