#!/bin/bash
# Focus the correct tmux pane when notification is clicked

tmux_socket="$1"
tmux_target="$2"

# Activate Ghostty
osascript -e 'tell application "Ghostty" to activate'

# Switch tmux to the correct pane
# Handle multiple clients by switching all of them
if [ -n "$tmux_socket" ] && [ -n "$tmux_target" ]; then
    /opt/homebrew/bin/tmux -S "$tmux_socket" select-window -t "${tmux_target%.*}"
    /opt/homebrew/bin/tmux -S "$tmux_socket" select-pane -t "$tmux_target"
fi
