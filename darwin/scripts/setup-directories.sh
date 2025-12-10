#!/bin/bash

# Setup development directory structure
# This script creates a standard directory layout for repositories

echo "Setting up development directories..."

# Base directories
DIRS=(
  "$HOME"
  "$HOME/uni"
  "$HOME/projects"
)

# Create directories if they don't exist
for dir in "${DIRS[@]}"; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    echo "✓ Created: $dir"
  else
    echo "→ Already exists: $dir"
  fi
done

echo ""
echo "Development directory structure ready!"
echo ""
echo "Structure:"
echo "  ~/work/         - Work and university projects"
echo "  ~/projects/     - Personal projects"
echo ""
