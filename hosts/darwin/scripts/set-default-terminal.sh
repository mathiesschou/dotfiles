#!/usr/bin/env bash

# Get Ghostty's bundle ID
GHOSTTY_ID=$(osascript -e 'id of app "Ghostty"' 2>/dev/null)

# Set as default for shell scripts
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add \
  "{LSHandlerContentType='public.shell-script';LSHandlerRoleAll='$GHOSTTY_ID';}"

/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister \
  -r -domain local -domain user -domain system
