# macOS Setup Todo

## Factory Reset
1. Shut down your Mac
2. Hold the power button until you see "Loading startup options"
3. Click **Options** → Continue
4. Open **Disk Utility**, select your disk, click **Erase**
5. Close Disk Utility, click **Reinstall macOS**

---

## 1. Install Xcode Command Line Tools
```sh
xcode-select --install
```

## 2. Set hostname
```sh
sudo scutil --set HostName mathies-macos
sudo scutil --set LocalHostName mathies-macos
sudo scutil --set ComputerName mathies-macos
```

## 3. Log in to App Store
Log in before rebuilding, otherwise Things 3, Flow and Numbers won't install.

## 4. Install Nix
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## 5. Fix /etc/zshrc conflict
nix-darwin cannot overwrite the existing zshrc — back it up first:
```sh
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin 2>/dev/null || true
```

## 6. Clone dotfiles
Clone via HTTPS first (SSH isn't set up yet):
```sh
git clone https://github.com/mathies/dotfiles.git ~/dotfiles
```

## 7. Install nix-darwin (first time only)
Do NOT install Homebrew manually — nix-homebrew handles it automatically.
```sh
nix run nix-darwin -- switch --flake ~/dotfiles#mathies-macos
```

## 8. Rebuild darwin (subsequent rebuilds)
```sh
dr
```
This will install all packages, configure macOS settings, set up SSH, install Claude Code, Codex, and MCP servers automatically.

## 9. Add SSH key to GitHub
The setup script generates a key automatically. Copy the public key and add it at https://github.com/settings/keys:
```sh
cat ~/.ssh/id_ed25519.pub
```
Then switch dotfiles remote to SSH:
```sh
cd ~/dotfiles && git remote set-url origin git@github.com:mathies/dotfiles.git
```

## 10. Add Context7 API key to Keychain
Get a free API key at https://context7.com/dashboard, then:
```sh
security add-generic-password -a "$USER" -s "context7-api-key" -w "YOUR_API_KEY"
```

## 11. Start Rift
```sh
rift service install && rift service start
```
Then go to **System Settings → Privacy & Security → Accessibility** and enable Rift.
Press `Option + Z` to activate Rift on the current Space.

## 12. Enable Adguard
Go to **System Settings → Extensions** and enable Adguard.

## 13. Configure Flow
Open Flow and configure work/break intervals and appearance manually.

## 14. Configure Ice
Open Ice and set up menu bar items visibility manually.

## 15. Configure Syncthing
Open http://localhost:8384 and add ThinkPad P50 as a remote device to sync ~/projects.

## 16. Remove system apps (optional)
Boot into Recovery (hold power button → Options → Continue → Terminal):
```sh
csrutil disable
```
Reboot, then run:
```sh
bash ~/dotfiles/scripts/remove-system-apps.sh
```
Boot into Recovery again and re-enable SIP:
```sh
csrutil enable
```

## 17. Manual System Settings
- **Mission Control** → uncheck "Automatically rearrange Spaces based on most recent use" (already set via nix, but verify)
- **Spaces** → cannot be disabled via nix-darwin, disable manually if desired
