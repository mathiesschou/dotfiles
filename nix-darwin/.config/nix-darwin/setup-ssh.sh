#!/usr/bin/env bash

SSH_KEY="$HOME/.ssh/id_ed25519"
SSH_PUB="$HOME/.ssh/id_ed25519.pub"

echo "Checking SSH key..."

if [ -f "$SSH_KEY" ]; then
  echo "SSH key already exists at $SSH_KEY"
else
  echo "No SSH key found. Generating new one..."
  
  # Get email (fallback to git config)
  EMAIL=$(git config --global user.email)
  if [ -z "$EMAIL" ]; then
    EMAIL="mathies@example.com"
  fi
  
  # Generate SSH key
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY" -N ""
  
  echo "SSH key generated!"
  echo ""
  echo "=========================================="
  echo "ADD THIS KEY TO GITHUB:"
  echo "=========================================="
  cat "$SSH_PUB"
  echo ""
  echo "https://github.com/settings/keys"
  echo "=========================================="
  echo ""
fi

# Test GitHub connection
echo "Testing GitHub connection..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "GitHub SSH connection works!"
else
  echo "GitHub SSH not configured yet."
  echo "Add your public key to: https://github.com/settings/keys"
  echo ""
  echo "Your public key:"
  cat "$SSH_PUB"
fi
