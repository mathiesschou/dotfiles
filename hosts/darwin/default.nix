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

    # AI tools
    claude-code
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

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
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies PATH="/run/current-system/sw/bin:/Users/mathies/.npm-global/bin:$PATH" /bin/bash -c '
      mkdir -p $HOME/.npm-global
      echo "prefix=$HOME/.npm-global" > $HOME/.npmrc

      MARKER="$HOME/.ai-tools-setup-done"
      if [ ! -f "$MARKER" ]; then
        npm install -g @openai/codex || true
        touch "$MARKER"
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
    ' || true
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.mathies = {
    name = "mathies";
    home = "/Users/mathies";
  };
}
