#!/bin/bash
# Create missing priority windows and sort

# Remember current active window index (more reliable than name)
current_window_index=$(tmux display-message -p "#{window_index}")
current_window_name=$(tmux display-message -p "#{window_name}")

# Check for ranger window
if ! tmux list-windows -F "#{window_name}" | grep -qi "ranger"; then
    tmux new-window -n ranger 'ranger'
fi

# Check for nvim window
if ! tmux list-windows -F "#{window_name}" | grep -qi "nvim"; then
    tmux new-window -n nvim 'nvim'
fi

# Check for claude window
if ! tmux list-windows -F "#{window_name}" | grep -qi "claude"; then
    tmux new-window -n claude
fi

# Check for log window
if ! tmux list-windows -F "#{window_name}" | grep -qi "log"; then
    tmux new-window -n log
fi

# If there's no zsh window, create one. If there are unnamed windows, rename the first one to zsh
if ! tmux list-windows -F "#{window_name}" | grep -q "^zsh$"; then
    # Look for the first window that might be a shell (common default names)
    first_shell=$(tmux list-windows -F "#{window_index}:#{window_name}" | grep -E ":(zsh|bash|sh|fish|.*shell.*|^[0-9]+)$" | head -1 | cut -d: -f1)
    if [[ -n "$first_shell" ]]; then
        tmux rename-window -t "$first_shell" zsh
    else
        tmux new-window -n zsh
    fi
fi

# Now sort them using the reliable script, passing the original window name
~/bin/tmux-sort-windows.sh "$current_window_name"
