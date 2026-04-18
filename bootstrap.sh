#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT=""

RUN_PACKAGES=0
RUN_LINKS=0
RUN_DEFAULTS=0
RUN_SSH=0
SECTIONS_SELECTED=0

usage() {
  cat <<EOF
Usage: bash $(basename "$0") [--all] [--packages] [--links] [--defaults] [--ssh] [--help]

With no flags, the script runs the full bootstrap:
  --packages --links --defaults --ssh

Sections:
  --packages   Install Homebrew packages from Brewfile
  --links      Symlink dotfiles into \$HOME and back up anything replaced
  --defaults   Apply macOS defaults, Dock changes, wallpaper, and hostname
  --ssh        Create/check ~/.ssh/id_ed25519 and test GitHub SSH auth
  --all        Run every section, including macOS defaults
  --help       Show this help text

Examples:
  bash bootstrap.sh
  bash bootstrap.sh --packages
  bash bootstrap.sh --links --ssh
  bash bootstrap.sh --defaults
  bash bootstrap.sh --all
EOF
}

log() {
  printf '%s\n' "$*"
}

warn() {
  printf 'Warning: %s\n' "$*" >&2
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  log "Homebrew not found. Installing it now..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if ! command -v brew >/dev/null 2>&1; then
    die "Homebrew install completed, but 'brew' is still not on PATH. Open a new shell and try again."
  fi
}

ensure_backup_root() {
  if [ -z "$BACKUP_ROOT" ]; then
    BACKUP_ROOT="$HOME/.dotfiles-backups/$TIMESTAMP"
    mkdir -p "$BACKUP_ROOT"
    log "Backing up replaced files to $BACKUP_ROOT"
  fi
}

relative_home_path() {
  local path="$1"

  if [[ "$path" == "$HOME/"* ]]; then
    printf '%s\n' "${path#"$HOME/"}"
  elif [ "$path" = "$HOME" ]; then
    printf 'home\n'
  else
    printf '%s\n' "$(basename "$path")"
  fi
}

backup_existing_target() {
  local source="$1"
  local dest="$2"
  local current_target=""
  local relative_dest=""
  local backup_path=""

  if [ -L "$dest" ]; then
    current_target="$(readlink "$dest" 2>/dev/null || true)"
    if [ "$current_target" = "$source" ]; then
      return 1
    fi
  fi

  if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
    return 0
  fi

  ensure_backup_root
  relative_dest="$(relative_home_path "$dest")"
  backup_path="$BACKUP_ROOT/$relative_dest"

  mkdir -p "$(dirname "$backup_path")"

  if [ -e "$backup_path" ] || [ -L "$backup_path" ]; then
    backup_path="$backup_path.$RANDOM"
  fi

  mv "$dest" "$backup_path"
  log "Backed up $dest -> $backup_path"
  return 0
}

link_path() {
  local source="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if backup_existing_target "$source" "$dest"; then
    ln -sfn "$source" "$dest"
    log "Linked $dest -> $source"
  else
    log "Already linked: $dest"
  fi
}

install_packages() {
  ensure_homebrew
  log "Installing packages..."
  brew bundle --file="$DOTFILES/Brewfile"
}

link_configs() {
  log "Linking configs..."
  mkdir -p "$HOME/.config"
  mkdir -p "$HOME/.config/ghostty"
  mkdir -p "$HOME/.config/tmux"
  mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"

  link_path "$DOTFILES/config/nvim" "$HOME/.config/nvim"
  link_path "$DOTFILES/config/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  link_path "$DOTFILES/config/ghostty/themes" "$HOME/.config/ghostty/themes"
  link_path "$DOTFILES/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
  link_path "$DOTFILES/config/starship.toml" "$HOME/.config/starship.toml"
  link_path "$DOTFILES/.zshrc" "$HOME/.zshrc"
  link_path "$DOTFILES/.gitconfig" "$HOME/.gitconfig"

  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
}

apply_macos_defaults() {
  log "Applying macOS settings..."

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

  killall Dock >/dev/null 2>&1 || true

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
    osascript -e 'tell application "System Events" to delete login item "Flux"' >/dev/null 2>&1 || true
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Flux.app", hidden:false}' >/dev/null 2>&1 || true
  fi

  # Computer name
  scutil --set ComputerName "mathies-macos"
  scutil --set HostName "mathies-macos"
  scutil --set LocalHostName "mathies-macos"

  # Wallpaper
  osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$DOTFILES/wallpapers/airballons.jpg\"" >/dev/null 2>&1 || warn "Could not set wallpaper automatically."

  # Apply settings
  if [ -x "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings" ]; then
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u >/dev/null 2>&1 || true
  fi
}

check_ssh() {
  local ssh_key="$HOME/.ssh/id_ed25519"
  local key_comment=""
  local ssh_output=""

  log "Checking SSH key..."

  if [ -f "$ssh_key" ]; then
    log "SSH key already exists."
  else
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    key_comment="$(git config --global user.email 2>/dev/null || true)"
    if [ -z "$key_comment" ]; then
      key_comment="$(whoami)@$(scutil --get LocalHostName 2>/dev/null || hostname)"
    fi

    ssh-keygen -t ed25519 -C "$key_comment" -f "$ssh_key" -N ""
    log ""
    log "=========================================="
    log "ADD THIS KEY TO GITHUB:"
    log "=========================================="
    cat "$ssh_key.pub"
    log "https://github.com/settings/keys"
    log "=========================================="
  fi

  ssh_output="$(ssh -T -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 git@github.com 2>&1 || true)"
  if printf '%s' "$ssh_output" | grep -q "successfully authenticated"; then
    log "GitHub SSH connection works."
  else
    log "GitHub SSH not configured yet — add your key to https://github.com/settings/keys"
    if [ -f "$ssh_key.pub" ]; then
      cat "$ssh_key.pub"
    fi
  fi
}

while [ $# -gt 0 ]; do
  case "$1" in
    --packages)
      RUN_PACKAGES=1
      SECTIONS_SELECTED=1
      ;;
    --links)
      RUN_LINKS=1
      SECTIONS_SELECTED=1
      ;;
    --defaults)
      RUN_DEFAULTS=1
      SECTIONS_SELECTED=1
      ;;
    --ssh)
      RUN_SSH=1
      SECTIONS_SELECTED=1
      ;;
    --all)
      RUN_PACKAGES=1
      RUN_LINKS=1
      RUN_DEFAULTS=1
      RUN_SSH=1
      SECTIONS_SELECTED=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1"
      ;;
  esac
  shift
done

if [ "$SECTIONS_SELECTED" -eq 0 ]; then
  RUN_PACKAGES=1
  RUN_LINKS=1
  RUN_DEFAULTS=1
  RUN_SSH=1
  log "Running full bootstrap: packages, links, macOS defaults, and SSH."
elif [ "$RUN_DEFAULTS" -eq 0 ]; then
  log "macOS defaults not selected. Existing system settings will be left alone."
fi

log "Dotfiles repo: $DOTFILES"

if [ "$RUN_PACKAGES" -eq 1 ]; then
  install_packages
fi

if [ "$RUN_LINKS" -eq 1 ]; then
  link_configs
fi

if [ "$RUN_DEFAULTS" -eq 1 ]; then
  apply_macos_defaults
fi

if [ "$RUN_SSH" -eq 1 ]; then
  check_ssh
fi

log ""
log "Done."

if [ -n "$BACKUP_ROOT" ]; then
  log "Backups saved to: $BACKUP_ROOT"
fi

log "Suggested next steps:"
if [ "$RUN_DEFAULTS" -eq 1 ]; then
  log "  - Log out and back in for macOS settings to take full effect."
fi
if [ "$RUN_LINKS" -eq 1 ]; then
  log "  - Open tmux and press prefix + I to install plugins."
fi
log "  - Set CapsLock -> Control in System Settings > Keyboard > Modifier Keys."
