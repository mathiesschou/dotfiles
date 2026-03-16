{ pkgs, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  # System packages (CLI tools that need to be system-wide)
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

    # Node.js (needed for MCP server setup)
    nodejs_20

    # AI tools
    claude-code
    
    # Database tools
    postgresql
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nix.enable = false;

  nixpkgs.config.darwin.apple_sdk.frameworks = [
    "Security"
    "CoreFoundation"
    "Foundation"
    "Iconv"
  ];

  environment.variables = {
    # Basic C/C++ toolchain (useful for per-project builds)
    CC = "${pkgs.clang}/bin/clang";
    CXX = "${pkgs.clang}/bin/clang++";
  };

  # System defaults
  system.defaults = {
    NSGlobalDomain = {
      _HIHideMenuBar = false;
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
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

      persistent-apps = [
        "/Applications/Ghostty.app"
        "/Applications/Zen.app"
      ];

      persistent-others = [
        "/Users/mathies/Downloads"
      ];
    };
  };

  # Nix configuration
  nix.settings.experimental-features = "nix-command flakes";

  # System-level zsh configuration
  programs.zsh.enable = true;

  # System version
  system.stateVersion = 5;
  system.primaryUser = "mathies";

  # Hostname configuration
  networking.computerName = "mathies-macos";
  networking.hostName = "mathies-macos";
  networking.localHostName = "mathies-macos";

  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Activation scripts
  system.activationScripts.extraActivation.text = ''
    # Configure keyboard input sources (English US and Danish)
    echo "Configuring keyboard input sources..."
    /usr/bin/sudo -u mathies /bin/bash -c '
      # Add English (US) input source
      /usr/bin/defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
        "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0</integer><key>KeyboardLayout Name</key><string>U.S.</string></dict>" \
        "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>9</integer><key>KeyboardLayout Name</key><string>Danish</string></dict>"
    ' || true

    # Set keyboard shortcut to switch between input sources (Control+Space)
    /usr/bin/sudo -u mathies /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>" || true
    /usr/bin/sudo -u mathies /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>786432</integer></array><key>type</key><string>standard</string></dict></dict>" || true

    echo "Keyboard input sources configured (English US and Danish with Control+Space to switch)"

    # Globe/Fn key → Show Emoji & Symbols
    /usr/bin/sudo -u mathies /usr/bin/defaults write com.apple.HIToolbox AppleFnUsageType -int 2

    # Apply settings immediately
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    # Install Rosetta 2 if needed (Apple Silicon only)
    if [[ $(uname -m) == "arm64" ]] && ! /usr/bin/pgrep -q oahd; then
      echo "Installing Rosetta 2..."
      /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    fi

    # Run setup script as user
    echo "Running default terminal setup..."
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./scripts/set-default-terminal.sh}

    # Setup SSH key
    echo "Checking SSH setup.."
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${../../scripts/setup-ssh.sh}

    # Remove quarantine from f.lux and ensure it's in Login Items
    if [[ -d "/Applications/Flux.app" ]]; then
      echo "Removing quarantine from f.lux..."
      /usr/bin/xattr -cr /Applications/Flux.app 2>/dev/null || true

      # Add f.lux to Login Items if not already there
      /usr/bin/sudo -u mathies /usr/bin/osascript -e 'tell application "System Events" to delete login item "Flux"' 2>/dev/null || true
      /usr/bin/sudo -u mathies /usr/bin/osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Flux.app", hidden:false}' 2>/dev/null || true
      echo "f.lux added to Login Items"
    fi

    # Set wallpaper
    echo "Setting wallpaper..."
    /usr/bin/sudo -u mathies /usr/bin/osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"/Users/mathies/dotfiles/wallpapers/airballons.jpg\""

    # Deploy Zen user.js to all profiles
    for profile in /Users/mathies/Library/Application\ Support/zen/Profiles/*/; do
      cp /Users/mathies/dotfiles/config/zen/user.js "$profile/user.js" 2>/dev/null || true
    done

    # Create projects folder if it doesn't exist
    if [[ ! -d "/Users/mathies/projects" ]]; then
      echo "Creating projects folder..."
      /usr/bin/sudo -u mathies mkdir -p /Users/mathies/projects
    fi

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
          echo "✓ Codex installed successfully"
          touch "$MARKER"
        else
          echo "✗ Codex installation failed"
          echo "  You may need to run: npm install -g @openai/codex"
        fi
      fi

      CLAUDE_MARKER="$HOME/.claude-mcp-setup-done"
      if [ ! -f "$CLAUDE_MARKER" ]; then
        echo "Setting up Claude MCP servers..."

        # Add serena
        OUTPUT=$(${pkgs.claude-code}/bin/claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server 2>&1)
        if echo "$OUTPUT" | grep -q "already exists"; then
          echo "✓ Claude: serena (already configured)"
        elif [ $? -eq 0 ]; then
          echo "✓ Claude: serena added"
        else
          echo "✗ Claude: serena failed"
        fi

        # Add sequential-thinking
        OUTPUT=$(${pkgs.claude-code}/bin/claude mcp add --scope user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking 2>&1)
        if echo "$OUTPUT" | grep -q "already exists"; then
          echo "✓ Claude: sequential-thinking (already configured)"
        elif [ $? -eq 0 ]; then
          echo "✓ Claude: sequential-thinking added"
        else
          echo "✗ Claude: sequential-thinking failed"
        fi

        # Add context7
        OUTPUT=$(${pkgs.claude-code}/bin/claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp 2>&1)
        if echo "$OUTPUT" | grep -q "already exists"; then
          echo "✓ Claude: context7 (already configured)"
        elif [ $? -eq 0 ]; then
          echo "✓ Claude: context7 added"
        else
          echo "✗ Claude: context7 failed"
        fi

        touch "$CLAUDE_MARKER"
      fi

      CODEX_MARKER="$HOME/.codex-mcp-setup-done"
      if [ ! -f "$CODEX_MARKER" ]; then
        echo "Setting up Codex MCP servers..."

        if [ ! -f "$HOME/.npm-global/bin/codex" ]; then
          echo "✗ Codex not found at $HOME/.npm-global/bin/codex, skipping MCP setup"
        else
          # Add serena
          OUTPUT=$($HOME/.npm-global/bin/codex mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server 2>&1)
          if echo "$OUTPUT" | grep -q "already exists"; then
            echo "✓ Codex: serena (already configured)"
          elif echo "$OUTPUT" | grep -q "Added"; then
            echo "✓ Codex: serena added"
          else
            echo "✗ Codex: serena failed"
          fi

          # Add sequential-thinking
          OUTPUT=$($HOME/.npm-global/bin/codex mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking 2>&1)
          if echo "$OUTPUT" | grep -q "already exists"; then
            echo "✓ Codex: sequential-thinking (already configured)"
          elif echo "$OUTPUT" | grep -q "Added"; then
            echo "✓ Codex: sequential-thinking added"
          else
            echo "✗ Codex: sequential-thinking failed"
          fi

          # Add context7
          OUTPUT=$($HOME/.npm-global/bin/codex mcp add context7 -- npx -y @upstash/context7-mcp 2>&1)
          if echo "$OUTPUT" | grep -q "already exists"; then
            echo "✓ Codex: context7 (already configured)"
          elif echo "$OUTPUT" | grep -q "Added"; then
            echo "✓ Codex: context7 added"
          else
            echo "✗ Codex: context7 failed"
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
