#!/usr/bin/env bash

# Get the current focused workspace from aerospace
FOCUSED=$(aerospace list-workspaces --focused)

BLUE=0xff89b4fa
GREY=0xff6c7086

# $1 is the workspace number passed from sketchybarrc
if [ "$1" = "$FOCUSED" ]; then
  sketchybar --set $NAME background.drawing=on background.color=$BLUE
else
  sketchybar --set $NAME background.drawing=off
fi
