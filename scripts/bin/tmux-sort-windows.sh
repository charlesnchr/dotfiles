#!/bin/bash
# Simple window sorting - move windows to correct positions

# Use provided window name or remember current active window name
current_window_name="${1:-$(tmux display-message -p "#{window_name}")}"

# First move everything to high temp numbers to avoid conflicts
for i in {1..20}; do
    if tmux list-windows | grep -q "^$i:"; then
        tmux move-window -s "$i" -t "$((100 + i))" 2>/dev/null
    fi
done

# Now assign priority windows to positions 1-5
pos=1

# zsh to position 1
zsh_win=$(tmux list-windows -F "#{window_index}:#{window_name}" | grep ":zsh$" | head -1 | cut -d: -f1)
if [[ -n "$zsh_win" ]]; then
    tmux move-window -s "$zsh_win" -t "$pos"
    pos=$((pos + 1))
fi

# ranger next
ranger_win=$(tmux list-windows | grep -i ":.*ranger" | head -1 | cut -d: -f1)
if [[ -n "$ranger_win" ]]; then
    tmux move-window -s "$ranger_win" -t "$pos"
    pos=$((pos + 1))
fi

# nvim next
nvim_win=$(tmux list-windows | grep -i ":.*nvim" | head -1 | cut -d: -f1)
if [[ -n "$nvim_win" ]]; then
    tmux move-window -s "$nvim_win" -t "$pos"
    pos=$((pos + 1))
fi

# claude next
claude_win=$(tmux list-windows | grep -i ":.*claude" | head -1 | cut -d: -f1)
if [[ -n "$claude_win" ]]; then
    tmux move-window -s "$claude_win" -t "$pos"
    pos=$((pos + 1))
fi

# log next
log_win=$(tmux list-windows | grep -i ":.*log" | head -1 | cut -d: -f1)
if [[ -n "$log_win" ]]; then
    tmux move-window -s "$log_win" -t "$pos"
    pos=$((pos + 1))
fi

# Move remaining windows back and renumber
tmux move-window -r

# Switch back to the window that was originally active
tmux select-window -t "$current_window_name" 2>/dev/null

