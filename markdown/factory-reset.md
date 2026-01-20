# Setting it up

1. Install Nix

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Restart the terminal.

2. Enable experimential features

```bash
sudo mkdir -p /etc/nix/
```

```bash
echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf
```

Restart the daemon.

```bash
sudo launchctl stop org.nixos.nix-daemon
```

```bash
sudo launchctl start org.nixos.nix-daemon
```

3. Move existing Config files

```bash
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
```

```bash
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
```

```bash
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

4. Fix darwin initialization

```bash
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/dotfiles#mathies-macos
```

---

# For NixOs-vm dev environment

1. After the first flake

```bash
enable-shared-mount
```

- Enables persistent VMware shared folder mounting at `/mnt/shared`
- Only needs to be run once, mounts automatically on future reboots
