#!/usr/bin/env bash
# ~/dotfiles/scripts/install-rosetta.sh

set -e

echo "Checking for Rosetta 2..."

if /usr/bin/pgrep -q oahd; then
    echo "Rosetta 2 is already installed"
    exit 0
fi

if [[ $(uname -m) != "arm64" ]]; then
    echo "Not an Apple Silicon Mac, Rosetta not needed"
    exit 0
fi

echo "Installing Rosetta 2..."
softwareupdate --install-rosetta --agree-to-license

echo "Rosetta 2 installed successfully"
