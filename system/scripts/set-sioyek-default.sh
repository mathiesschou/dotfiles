#!/usr/bin/env bash
# ~/dotfiles/scripts/set-sioyek-default.sh

set -e

# Find Sioyek app
SIOYEK_PATH="/Applications/Sioyek.app"

if [[ ! -d "$SIOYEK_PATH" ]]; then
    echo "Sioyek not found at $SIOYEK_PATH"
    echo "  Install it first with: brew install --cask sioyek"
    exit 1
fi

# Get bundle identifier
BUNDLE_ID=$(mdls -name kMDItemCFBundleIdentifier -r "$SIOYEK_PATH")

if [[ -z "$BUNDLE_ID" ]]; then
    echo "Could not find Sioyek bundle identifier"
    exit 1
fi

echo "Setting Sioyek ($BUNDLE_ID) as default PDF viewer..."

# Set for .pdf files
duti -s "$BUNDLE_ID" .pdf all

