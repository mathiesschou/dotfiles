#!/bin/bash

# Check and create "work" session
if ! tmux has-session -t work 2>/dev/null; then
  tmux new -s work -d
fi

# Check and create "personal" session
if ! tmux has-session -t personal 2>/dev/null; then
  tmux new -s personal -d
fi

# Check and create "tri" session
if ! tmux has-session -t tri 2>/dev/null; then
  tmux new -s tri -d
  tmux send-keys -t tri 'cd ~/projects/tools' Enter
fi

# Check and create "notes" session
if ! tmux has-session -t notes 2>/dev/null; then
  tmux new -s notes -d
  tmux send-keys -t notes 'cd ~/notes' Enter
fi

# Attach to work session
tmux attach -t work
