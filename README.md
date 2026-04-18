# dotfiles

Personal macOS dotfiles and bootstrap setup.

## Bootstrap

Run the full bootstrap:

```bash
bash ~/dotfiles/bootstrap.sh
```

That installs your Brewfile packages, restores config links, applies macOS defaults, and checks SSH. Existing config files that get replaced are backed up to `~/.dotfiles-backups/<timestamp>`.

If you only want to rerun part of the setup:

```bash
bash ~/dotfiles/bootstrap.sh --defaults
```

You can also use `--packages`, `--links`, `--ssh`, or `--all`.
