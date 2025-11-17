#!/bin/bash

# Get Spotify state using osascript
if pgrep -x "Spotify" > /dev/null; then
  STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)

  if [ "$STATE" = "playing" ]; then
    TRACK=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
    ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)

    if [ -n "$TRACK" ] && [ -n "$ARTIST" ]; then
      # Limit length to prevent bar overflow
      MAX_LENGTH=30
      DISPLAY="${ARTIST} - ${TRACK}"
      if [ ${#DISPLAY} -gt $MAX_LENGTH ]; then
        DISPLAY="${DISPLAY:0:$MAX_LENGTH}..."
      fi

      sketchybar --set "$NAME" icon=" " label="$DISPLAY" drawing=on
    else
      sketchybar --set "$NAME" drawing=off
    fi
  else
    sketchybar --set "$NAME" drawing=off
  fi
else
  sketchybar --set "$NAME" drawing=off
fi
