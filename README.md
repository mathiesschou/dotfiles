# dotfiles

My personal dotfiles for macOS and a reproducible NixOS dev environment.

Nix makes the entire system declarative and reproducible. One config file defines everything — packages, settings, dotfiles. Rebuilding a machine from scratch takes minutes, not hours. No more "works on my machine", forgetting what I installed, or dependency conflicts.

This setup is tailored to my workflow and hardware. I'm currently using this on a Macbook Pro M4. It's not optimally written, but it works. If you want to use this as a starting point, be aware that you'll need to change usernames, paths, and hardware-specific settings throughout the config. :-)

The NixOS VM runs in VMware Fusion with no noticeable performance issues on either the macOS or NixOS side. Niri runs smooth. I use shared folders for project files, NAT networking, over half of available CPU cores, full 3D acceleration, native resolution, and 150 GB disk.

Inspired by [Mitchell Hashimoto](https://github.com/mitchellh/nixos-config).
