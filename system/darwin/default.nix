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
    duti
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

  nixpkgs.config.darwin.apple_sdk.frameworks = [
    "Security"
    "CoreFoundation"
    "Foundation"
    "Iconv"
  ];

  environment.variables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";

    # IMPORTANT: make Rust use Nix toolchain
    CC = "${pkgs.clang}/bin/clang";
    CXX = "${pkgs.clang}/bin/clang++";
    AR = "${pkgs.llvm}/bin/llvm-ar";
    CFLAGS = "-I${pkgs.libiconv}/include";
    LDFLAGS = "-L${pkgs.libiconv}/lib";
  };

  # System defaults
  system.defaults = {
    NSGlobalDomain = {
      _HIHideMenuBar = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      NewWindowTarget = "Home";
    };

    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;

      persistent-apps = [
        "/Applications/Ghostty.app"
        "/System/Cryptexes/App/System/Applications/Safari.app"
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
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./scripts/setup-ssh.sh}

    # Remove quarantine from Sioyek
    if [[ -d "/Applications/Sioyek.app" ]]; then
      echo "Removing quarantine from Sioyek..."
      /usr/bin/xattr -cr /Applications/Sioyek.app 2>/dev/null || true
    fi

    # Remove quarantine from f.lux and ensure it's in Login Items
    if [[ -d "/Applications/Flux.app" ]]; then
      echo "Removing quarantine from f.lux..."
      /usr/bin/xattr -cr /Applications/Flux.app 2>/dev/null || true
      
      # Add f.lux to Login Items if not already there
      /usr/bin/sudo -u mathies /usr/bin/osascript -e 'tell application "System Events" to delete login item "Flux"' 2>/dev/null || true
      /usr/bin/sudo -u mathies /usr/bin/osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Flux.app", hidden:false}' 2>/dev/null || true
      echo "f.lux added to Login Items"
    fi

    # Set Sioyek as default PDF viewer
    if [[ -d "/Applications/Sioyek.app" ]]; then
      echo "Setting Sioyek as default PDF viewer..."
      BUNDLE_ID=$(/usr/bin/mdls -name kMDItemCFBundleIdentifier -r "/Applications/Sioyek.app" 2>/dev/null || echo "")
      if [[ -n "$BUNDLE_ID" ]]; then
        /usr/bin/sudo -u mathies ${pkgs.duti}/bin/duti -s "$BUNDLE_ID" .pdf all 2>/dev/null || true
        echo "Sioyek set as default PDF viewer"
      fi
    fi

    # Setup npm global directory and install AI tools
    echo "Setting up AI CLI tools..."
    /usr/bin/sudo -u mathies /bin/bash -c '
      export HOME=/Users/mathies
      mkdir -p $HOME/.npm-global
      echo "prefix=$HOME/.npm-global" > $HOME/.npmrc
      export PATH="$HOME/.npm-global/bin:${pkgs.nodejs_20}/bin:$PATH"
      npm install -g @anthropic-ai/claude-code
      npm install -g @openai/codex
      npm install -g context7
    ' || true

    # Setup Claude Code MCP servers
    echo "Setting up Claude Code MCP servers..."
    /usr/bin/sudo -u mathies /bin/bash -c '
      export HOME=/Users/mathies
      export PATH="$HOME/.npm-global/bin:/opt/homebrew/bin:${pkgs.nodejs_20}/bin:$PATH"
      MARKER_FILE="$HOME/.claude-mcp-setup-done"

      # Check if MCP servers are already configured using marker file
      # This avoids running "claude mcp list" which starts the servers and triggers Safari
      if [ ! -f "$MARKER_FILE" ]; then
        echo "Installing Serena MCP server..."
        claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server || true

        echo "Installing Sequential Thinking MCP server..."
        claude mcp add --scope user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true

        echo "Installing Context7 MCP server..."
        claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp || true

        # Create marker file to indicate setup is complete
        touch "$MARKER_FILE"
        echo "Claude Code MCP servers configured"
      else
        echo "Claude Code MCP servers already configured (skipping)"
      fi
    ' || true

    # Setup Codex MCP servers
    echo "Setting up Codex MCP servers..."
    /usr/bin/sudo -u mathies /bin/bash -c '
      export HOME=/Users/mathies
      export PATH="$HOME/.npm-global/bin:/opt/homebrew/bin:${pkgs.nodejs_20}/bin:$PATH"
      MARKER_FILE="$HOME/.codex-mcp-setup-done"

      # Check if MCP servers are already configured using marker file
      # This provides a more reliable check without potentially starting servers
      if [ ! -f "$MARKER_FILE" ]; then
        echo "Installing Serena MCP server..."
        codex mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server || true

        echo "Installing Sequential Thinking MCP server..."
        codex mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true

        echo "Installing Context7 MCP server..."
        codex mcp add context7 -- npx -y @upstash/context7-mcp || true

        # Create marker file to indicate setup is complete
        touch "$MARKER_FILE"
        echo "Codex MCP servers configured"
      else
        echo "Codex MCP servers already configured (skipping)"
      fi
    ' || true

    # Restart SystemUIServer to apply menubar changes
    /usr/bin/killall SystemUIServer 2>/dev/null || true

    # Setup Rust tools system-wide
    echo "Running Rust setup..."
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./scripts/setup-rust.sh}

    # Clear Neovim cache to ensure fresh plugin configuration
    echo "Clearing Neovim cache..."
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./scripts/clear-nvim-cache.sh}

    # Set random wallpaper
    echo "Setting random wallpaper..."
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./scripts/set-random-wallpaper.sh}
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.mathies = {
    name = "mathies";
    home = "/Users/mathies";
  };
}
