#!/bin/bash
# Requires SIP disabled: boot Recovery → csrutil disable

set -euo pipefail

if csrutil status | grep -q "enabled"; then
  echo "SIP is enabled. Disable it first from Recovery."
  exit 1
fi

APPS=(
  "/System/Applications/Chess.app"
  "/System/Applications/Stickies.app"
  "/System/Applications/Stocks.app"
  "/System/Applications/Tips.app"
  "/System/Applications/Freeform.app"
  "/System/Applications/Games.app"
  "/System/Applications/Books.app"
  "/System/Applications/Podcasts.app"
  "/System/Applications/TV.app"
  "/System/Applications/Music.app"
  "/System/Applications/News.app"
  "/System/Applications/Journal.app"
  "/System/Applications/Photo Booth.app"
  "/System/Applications/Clock.app"
  "/System/Applications/VoiceMemos.app"
  "/System/Applications/Weather.app"
  "/System/Applications/Phone.app"
  "/System/Applications/Automator.app"
  "/System/Applications/Font Book.app"
  "/System/Applications/Image Capture.app"
  "/System/Applications/Utilities/Magnifier.app"
  "/System/Applications/Utilities/Boot Camp Assistant.app"
  "/System/Applications/Utilities/AirPort Utility.app"
  "/System/Applications/Utilities/Bluetooth File Exchange.app"
  "/System/Applications/Utilities/Grapher.app"
  "/System/Applications/Utilities/ColorSync Utility.app"
  "/System/Applications/Utilities/Digital Color Meter.app"
  "/System/Applications/Utilities/Script Editor.app"
  "/System/Applications/Reminders.app"
  "/System/Applications/Photos.app"
  "/System/Applications/Siri.app"
  "/System/Applications/TextEdit.app"
  "/System/Applications/Utilities/VoiceOver Utility.app"
  "/System/Applications/Utilities/Audio MIDI Setup.app"
  "/System/Applications/Utilities/Print Center.app"
  "/System/Applications/Utilities/Screen Sharing.app"
)

for app in "${APPS[@]}"; do
  [[ -d "$app" ]] && sudo rm -rf "$app" && echo "Removed: $(basename "$app")"
done

echo "Done. Re-enable SIP from Recovery: csrutil enable"
