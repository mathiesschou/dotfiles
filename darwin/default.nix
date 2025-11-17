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
  ];

  environment.variables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  # System defaults
  system.defaults = {
    NSGlobalDomain = {
      _HIHideMenuBar = true;
    };

    finder = {
      AppleShowAllExtensions = true;
    };

    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;

      persistent-apps = [
        "/Applications/Ghostty.app"
        "/System/Cryptexes/App/System/Applications/Safari.app"
        "/System/Applications/Mail.app"
        "/System/Applications/Calendar.app"
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

  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Activation scripts
  system.activationScripts.extraActivation.text = ''
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

    # Setup development directories
    echo "Setting up development directories..."
    /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./scripts/setup-directories.sh}

    # Remove quarantine from Sioyek
    if [[ -d "/Applications/Sioyek.app" ]]; then
      echo "Removing quarantine from Sioyek..."
      /usr/bin/xattr -cr /Applications/Sioyek.app 2>/dev/null || true
    fi

    # Set Sioyek as default PDF viewer
    if [[ -d "/Applications/Sioyek.app" ]]; then
      echo "Setting Sioyek as default PDF viewer..."
      BUNDLE_ID=$(/usr/bin/mdls -name kMDItemCFBundleIdentifier -r "/Applications/Sioyek.app" 2>/dev/null || echo "")
      if [[ -n "$BUNDLE_ID" ]]; then
        /usr/bin/sudo -u mathies ${pkgs.duti}/bin/duti -s "$BUNDLE_ID" .pdf all 2>/dev/null || true
        echo "✓ Sioyek set as default PDF viewer"
      fi
    fi

    # Start sketchybar service
    echo "Ensuring sketchybar service..."
    /usr/bin/sudo -u mathies /opt/homebrew/bin/brew services restart sketchybar 2>/dev/null || true

    # Setup npm global directory and install Claude Code
    echo "Setting up Claude Code..."
    /usr/bin/sudo -u mathies /bin/bash -c '
      export HOME=/Users/mathies
      mkdir -p $HOME/.npm-global
      echo "prefix=$HOME/.npm-global" > $HOME/.npmrc
      export PATH="$HOME/.npm-global/bin:${pkgs.nodejs_20}/bin:$PATH"
      npm install -g @anthropic-ai/claude-code
    ' || true

    # Restart SystemUIServer to apply menubar changes
    /usr/bin/killall SystemUIServer 2>/dev/null || true
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.mathies = {
    name = "mathies";
    home = "/Users/mathies";
  };
}
