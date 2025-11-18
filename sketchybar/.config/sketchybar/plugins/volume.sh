#!/bin/bash

VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

if [[ "$MUTED" == "true" ]]; then
    ICON="󰝟"
    LABEL="Muted"
else
    if [[ $VOLUME -eq 0 ]]; then
        ICON="󰝟"
    elif [[ $VOLUME -lt 33 ]]; then
        ICON="󰕿"
    elif [[ $VOLUME -lt 66 ]]; then
        ICON="󰖀"
    else
        ICON="󰕾"
    fi

    LABEL="${VOLUME}%"
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
