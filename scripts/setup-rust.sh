#!/usr/bin/env bash
set -euo pipefail

echo "Running Rust system setup..."

# Ensure Nix profile binaries are on PATH when run via sudo
USER_NAME=${USER:-$(id -un)}
NIX_PATHS=(
  "/run/current-system/sw/bin"
  "/nix/var/nix/profiles/default/bin"
  "/nix/var/nix/profiles/per-user/${USER_NAME}/profile/bin"
  "$HOME/.nix-profile/bin"
)
for path_dir in "${NIX_PATHS[@]}"; do
  if [ -d "$path_dir" ] && [[ ":$PATH:" != *":$path_dir:"* ]]; then
    PATH="$path_dir:$PATH"
  fi
done
export PATH

# Detect binaries (installed via Nix)
RUSTC_PATH=$(command -v rustc || true)
CARGO_PATH=$(command -v cargo || true)
ANALYZER_PATH=$(command -v rust-analyzer || true)

# --- Validate that Nix packages were installed ---
if [ -z "$RUSTC_PATH" ]; then
  echo "rustc not found in PATH"
  echo "Make sure you've added rustc to environment.systemPackages"
  exit 0
fi

if [ -z "$CARGO_PATH" ]; then
  echo "cargo not found in PATH"
  echo "Make sure cargo is installed system-wide via Nix"
  exit 0
fi

if [ -z "$ANALYZER_PATH" ]; then
  echo "rust-analyzer not found"
  echo "Add `rust-analyzer` to systemPackages"
  exit 0
fi

echo "Rust compiler: $RUSTC_PATH"
echo "Cargo: $CARGO_PATH"
echo "Rust Analyzer: $ANALYZER_PATH"

# --- Create a default cargo home if missing ---
if [ ! -d "$HOME/.cargo" ]; then
  echo "Creating ~/.cargo directory..."
  mkdir -p "$HOME/.cargo"
  chmod 755 "$HOME/.cargo"
fi

# --- Cargo bin directory ---
if [ ! -d "$HOME/.cargo/bin" ]; then
  mkdir -p "$HOME/.cargo/bin"
fi

# --- Validate toolchain ---
echo "Checking Rust versions..."
rustc --version || true
cargo --version || true
rust-analyzer --version || true

echo "Rust environment looks good!"
exit 0
