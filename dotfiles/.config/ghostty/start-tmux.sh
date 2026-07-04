#!/bin/zsh

SESSION_NAME="tmux-ghostty"

TMUX="/opt/homebrew/bin/tmux"
# Check if the session already exists
$TMUX has-session -t $SESSION_NAME 2>/dev/null

if [ $? -eq 0 ]; then
  # If the session exists, reattach to it
  $TMUX attach-session -t $SESSION_NAME
else
  # If the session doesn't exist, start a new one
  $TMUX new-session -s $SESSION_NAME -d
  $TMUX attach-session -t $SESSION_NAME
fi

