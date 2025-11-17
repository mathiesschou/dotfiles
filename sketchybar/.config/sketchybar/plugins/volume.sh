#!/bin/bash

VOLUME=$(osascript -e "output volume of (get volume settings)")

if [[ $VOLUME -eq 0 ]]; then
    ICON="󰝟"
elif [[ $VOLUME -lt 33 ]]; then
    ICON="󰕿"
elif [[ $VOLUME -lt 66 ]]; then
    ICON="󰖀"
else
    ICON="󰕾"
fi

sketchybar --set $NAME icon="$ICON" label="$VOLUME%"
