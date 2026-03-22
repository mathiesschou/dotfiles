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
```

```sh
sudo scutil --set LocalHostName mathies-macos
```

```sh
sudo scutil --set ComputerName mathies-macos
```

## 3. Log in to App Store

Log in before rebuilding, otherwise App Store apps will not install.

## 4. Install Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Activate nix in the same shell

```sh
/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
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
git clone https://github.com/mathiesschou/dotfiles.git
```

## 7. Install nix-darwin (first time only)

Do NOT install Homebrew manually — nix-homebrew handles it automatically.

```sh
sudo nix run nix-darwin -- switch --flake ~/dotfiles#mathies-macos
```
``

**Note:** If Codex or MCP servers fail to install, remove the marker files and rebuild:

```sh
rm ~/.ai-tools-setup-done ~/.claude-mcp-setup-done ~/.codex-mcp-setup-done
dr
```

## 8. Initialize theme system

- `light` — Switch to Catppuccin Latte (light theme)
- `dark` — Switch to Catppuccin Mocha (dark theme)

This synchronizes themes across Ghostty, Tmux, and Neovim automatically.

## 9. Add SSH key to GitHub

The setup script generates a key automatically. Copy the public key and add it at https://github.com/settings/keys:

```sh
cat ~/.ssh/id_ed25519.pub
```

Then switch dotfiles remote to SSH:

```sh
cd ~/dotfiles && git remote set-url origin git@github.com:mathiesschou/dotfiles.git
```

## 10. Add Context7 API key to Keychain

The Context7 MCP server (used by both Claude Code and Codex) requires an API key.

1. Get a free API key at https://context7.com/dashboard
2. Add it to macOS Keychain:

```sh
security add-generic-password -a "$USER" -s "context7-api-key" -w "YOUR_API_KEY"
```

Replace `YOUR_API_KEY` with the actual key from the dashboard.

**Note:** `serena` and `sequential-thinking` MCP servers don't require API keys and will work automatically.

## 11. Zen Browser

Setup Zen as default browser and log in for sync

## 12. Enable Adguard

Go to **System Settings → Extensions** and enable Adguard.

## 13. Configure Flow

Open Flow and configure work/break intervals and appearance manually.

## 14. Configure workspaces and window management

Open Flashspace and Rectangle and configure windows.

Flashspace: 6-6 workspaces: navigate spaces with opt + number, and automate open. 
Rectangle: Check `rectangle.png` in this repo and copy setting. 
- Make both launch at login. 

## 16. Configure menu bar items

Manually hide unwanted menu bar icons in each app's settings.

## 17. Add dotfiles to Finder's favourite list (and others)

