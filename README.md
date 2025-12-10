# dotfiles

## Quick reinstall after reset
1. In terminal `git --version`, automatically installs developer tools.
2. Install Nix with flakes enabled: `sh <(curl -L https://nixos.org/nix/install)` (then ensure `nix.settings.experimental-features = nix-command flakes` in `/etc/nix/nix.conf` if prompted).
3. Activate Nix `source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh?
2. Clone this repo back to `~/dotfiles`.
3. Run `cd ~/dotfiles && darwin-rebuild switch --flake .#mathies-macos` (or just use the `dr` alias).
4. Re-add any required secrets, e.g. Context7 keychain entry: `security add-generic-password -a "$USER" -s "context7-api-key" -w "<KEY>"`.

Home-manager only deploys files tracked in git, so run `git add` before rebuilding.
