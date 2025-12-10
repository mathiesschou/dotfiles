# macOS Setup — Nix + nix-darwin + Home Manager  
For clean macOS installations (factory reset)

This repository contains a fully declarative macOS setup using **Nix**, **nix-darwin**, and **Home Manager**.

---

# Before you begin — determine your hostname

Your system configuration is selected using your machine's hostname.

Check it with:

```bash
scutil --get LocalHostName
```

Use this value in all commands where `<hostname>` appears:

```
--flake .#<hostname>
```

If you want a different name, change it inside `flake.nix`.

---

## 1. Install Nix (multi-user mode)

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Restart your terminal or run:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

---

## 2. Clone the dotfiles repo

```bash
git clone https://github.com/mathiesschou/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

---

## 3. Enable flakes + nix-command features

```bash
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

---

## 4. Install nix-darwin (first-time install)

Run:

```bash
nix run nix-darwin -- switch --flake .#<hostname>
```

If you see:

```
Unexpected files in /etc, aborting activation
```

Remove conflicting files:

```bash
sudo rm /etc/nix/nix.conf
sudo rm /etc/bashrc
sudo rm /etc/zshrc
```

Then retry:

```bash
nix run nix-darwin -- switch --flake .#<hostname>
```

---

## 5. First-time system activation (must be run as root)

```bash
sudo darwin-rebuild switch --flake .#<hostname>
```

If `darwin-rebuild` is not found, locate it:

```bash
ls /nix/store/*darwin-rebuild*/bin/darwin-rebuild
```

Then run it via full path:

```bash
sudo /nix/store/...-darwin-rebuild/bin/darwin-rebuild switch --flake .#<hostname>
```

After the first successful activation, `darwin-rebuild` will become available normally.

---

# 🔁 Future updates

```bash
darwin-rebuild switch --flake .#<hostname>
```
