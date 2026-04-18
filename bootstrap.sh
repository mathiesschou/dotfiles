#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"

# --- Packages ---
echo "Installing packages..."
brew bundle --file="$DOTFILES/Brewfile"

# --- Symlinks ---
echo "Linking configs..."
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"

ln -sfn "$DOTFILES/config/nvim"                  "$HOME/.config/nvim"
ln -sfn "$DOTFILES/config/ghostty/config"        "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
ln -sfn "$DOTFILES/config/ghostty/themes"        "$HOME/.config/ghostty/themes"
ln -sfn "$DOTFILES/config/tmux/tmux.conf"        "$HOME/.config/tmux/tmux.conf"
ln -sfn "$DOTFILES/config/starship.toml"         "$HOME/.config/starship.toml"
ln -sfn "$DOTFILES/.zshrc"                       "$HOME/.zshrc"
ln -sfn "$DOTFILES/.gitconfig"                   "$HOME/.gitconfig"

# --- tmux plugin manager ---
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# --- macOS defaults ---
echo "Applying macOS settings..."

# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 13

# Trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write NSGlobalDomain "com.apple.trackpad.scaling" -float 1.5

# Finder
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock mru-spaces -bool false

defaults write com.apple.dock persistent-apps -array \
  "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Ghostty.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>" \
  "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Safari.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

defaults write com.apple.dock persistent-others -array \
  "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Users/mathiesschou/Downloads</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

killall Dock

# Fn key for emojis
defaults write com.apple.HIToolbox AppleFnUsageType -int 2

# Input sources: US + Danish
defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
  "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0</integer><key>KeyboardLayout Name</key><string>U.S.</string></dict>" \
  "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>9</integer><key>KeyboardLayout Name</key><string>Danish</string></dict>"

# Ctrl+Space to switch input source
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>786432</integer></array><key>type</key><string>standard</string></dict></dict>"

# f.lux login item
if [[ -d "/Applications/Flux.app" ]]; then
  xattr -cr /Applications/Flux.app 2>/dev/null || true
  osascript -e 'tell application "System Events" to delete login item "Flux"' &>/dev/null || true
  osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Flux.app", hidden:false}' &>/dev/null || true
fi

# Computer name
scutil --set ComputerName "mathies-macos"
scutil --set HostName "mathies-macos"
scutil --set LocalHostName "mathies-macos"

# Wallpaper
osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$DOTFILES/wallpapers/airballons.jpg\""

# Apply settings
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# --- SSH ---
echo "Checking SSH key..."
SSH_KEY="$HOME/.ssh/id_ed25519"
if [ -f "$SSH_KEY" ]; then
  echo "SSH key already exists."
else
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  ssh-keygen -t ed25519 -C "$(git config --global user.email)" -f "$SSH_KEY" -N ""
  echo ""
  echo "=========================================="
  echo "ADD THIS KEY TO GITHUB:"
  echo "=========================================="
  cat "$SSH_KEY.pub"
  echo "https://github.com/settings/keys"
  echo "=========================================="
fi

if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "GitHub SSH connection works."
else
  echo "GitHub SSH not configured yet — add your key to https://github.com/settings/keys"
  cat "$SSH_KEY.pub"
fi

echo ""
echo "Done! Next steps:"
echo "  1. Log out and back in for macOS settings to take effect"
echo "  2. Open tmux and press prefix + I to install plugins"
echo "  3. Set CapsLock → Control in System Settings > Keyboard > Modifier Keys"
