#!/bin/bash

STATE_FILE="/tmp/sketchybar_pomodoro_state"
WORK_DURATION=1500  # 25 minutes in seconds
BREAK_DURATION=300  # 5 minutes in seconds

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "stopped:0:work" > "$STATE_FILE"
fi

# Read current state
IFS=':' read -r status remaining mode < "$STATE_FILE"

# Handle click events
if [ "$SENDER" = "mouse.clicked" ]; then
    case "$status" in
        stopped)
            # Start work session
            if [ "$mode" = "work" ]; then
                echo "running:$WORK_DURATION:work" > "$STATE_FILE"
            else
                echo "running:$BREAK_DURATION:break" > "$STATE_FILE"
            fi
            ;;
        running)
            # Pause
            echo "paused:$remaining:$mode" > "$STATE_FILE"
            ;;
        paused)
            # Resume
            echo "running:$remaining:$mode" > "$STATE_FILE"
            ;;
    esac
    # Re-read state after update
    IFS=':' read -r status remaining mode < "$STATE_FILE"
fi

# Handle right-click for reset
if [ "$SENDER" = "mouse.clicked.right" ]; then
    echo "stopped:0:work" > "$STATE_FILE"
    IFS=':' read -r status remaining mode < "$STATE_FILE"
fi

# Update timer if running
if [ "$status" = "running" ]; then
    remaining=$((remaining - 1))

    # Check if timer finished
    if [ $remaining -le 0 ]; then
        if [ "$mode" = "work" ]; then
            # Work session finished, switch to break
            osascript -e 'display notification "Time for a break!" with title "🍅 Pomodoro Complete" sound name "Glass"'
            echo "stopped:0:break" > "$STATE_FILE"
        else
            # Break finished, switch to work
            osascript -e 'display notification "Break is over! Ready to focus?" with title "☕ Break Complete" sound name "Glass"'
            echo "stopped:0:work" > "$STATE_FILE"
        fi
        IFS=':' read -r status remaining mode < "$STATE_FILE"
    else
        echo "running:$remaining:$mode" > "$STATE_FILE"
    fi
fi

# Format display
minutes=$((remaining / 60))
seconds=$((remaining % 60))

# Set icon and color based on mode and status
if [ "$mode" = "work" ]; then
    ICON="🍅"
    COLOR="0xfff38ba8"  # RED
else
    ICON="☕"
    COLOR="0xffa6e3a1"  # GREEN
fi

# Gray out if stopped
if [ "$status" = "stopped" ]; then
    COLOR="0xff6c7086"  # GREY
fi

# Display format
if [ "$status" = "stopped" ]; then
    if [ "$mode" = "work" ]; then
        LABEL="Ready"
    else
        LABEL="Break"
    fi
else
    LABEL=$(printf "%02d:%02d" $minutes $seconds)
fi

# Update if paused
if [ "$status" = "paused" ]; then
    LABEL="$LABEL ⏸"
fi

sketchybar --set $NAME \
    icon="$ICON" \
    label="$LABEL" \
    icon.color="$COLOR" \
    label.color="$COLOR"
