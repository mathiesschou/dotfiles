{
  description = "mathies-macos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { self, nix-darwin, nixpkgs, nix-homebrew }: {
    darwinConfigurations."mathies-macos" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "mathies";
          };
        }
      ({ pkgs, ... }: {
       environment.systemPackages = with pkgs; [
       neovim
       git
       stow
       zsh-powerlevel10k
       tree
       duti # default apps for certain filetypes

# for neovim
       ripgrep
       fd
       gcc
       nodejs_20
       lazygit
       fzf
       ];					

       homebrew = {
       enable = true;

       casks = [
         "ghostty"
           "zoom"
           "font-meslo-lg-nerd-font"
           "sioyek"
           "microsoft-outlook"
       ];

       onActivation = {
         cleanup = "zap";
         autoUpdate = true;
         upgrade = true;
       };
       };

       system.defaults = {
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


       nix.settings.experimental-features = "nix-command flakes";
       programs.zsh.enable = true;
       programs.zsh = {
         promptInit = ''
           source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
           '';
       };



       system.stateVersion = 5;
       system.primaryUser = "mathies";

       system.keyboard = {
         enableKeyMapping = true;
         remapCapsLockToControl = true;
       };

       system.activationScripts.extraActivation.text = ''
# Apply settings immediately
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# Install Rosetta 2 if needed (Apple Silicon only)
  if [[ $(uname -m) == "arm64" ]] && ! /usr/bin/pgrep -q oahd; then
    echo "Installing Rosetta 2..."
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
  fi

# Run setup script as user (we're root, so use sudo -u)
         echo "Running default terminal setup..."
         /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./set-default-terminal.sh}

# Setup SSH key
       echo "Checking SSH setup.."
         /usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./setup-ssh.sh}

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
       '';


       nixpkgs.hostPlatform = "aarch64-darwin";


       users.users.mathies = {
         name = "mathies";
         home = "/Users/mathies";
       };
      })	
      ];
    };
  };
}
