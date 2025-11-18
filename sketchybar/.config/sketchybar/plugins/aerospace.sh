#!/usr/bin/env bash

# Get the current focused workspace from aerospace
FOCUSED=$(aerospace list-workspaces --focused)

ACTIVE_COLOR=${WHITE:-0xffcdd6f4}
INACTIVE_COLOR=${GREY:-0xff6c7086}

# $1 is the workspace number passed from sketchybarrc
if [ "$1" = "$FOCUSED" ]; then
  sketchybar --animate tanh 5 --set "$NAME" icon.color=$ACTIVE_COLOR
else
  sketchybar --animate tanh 5 --set "$NAME" icon.color=$INACTIVE_COLOR
fi
