#!/bin/bash
: ' ----------------------------------------
* Creation Time : Sat 26 Aug 2023 14:20:47 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# Kill existing tmux server
tmux kill-server

# Start a new tmux session in detached mode
tmux new-session -d -s my_session

# Attach to the tmux session
alacritty -o "window.dimensions.lines=40" -o "window.dimensions.columns=240" -e sh -c "tmux attach -t my_session" &

# Store the process ID of the last background command
TMUX_PID=$!

sleep 0.5

# Open Vim in the first pane
tmux send-keys -t my_session:0 'vim' C-m

# Split the pane horizontally
tmux split-window -h

# Resize the first pane to 30% of the window width
tmux resize-pane -t my_session:0.0 -x 30%

# sleep for 100ms
sleep 0.1

# SSH into the server and attach to tmux on the server
tmux send-keys -t my_session:0 'ssh msi' C-m

sleep 0.5

tmux send-keys -t my_session:0 'tmux attach' C-m

# Split the pane horizontally
tmux split-window -h

# sleep for 100ms
sleep 0.1

# SSH into the server and attach to tmux on the server
tmux send-keys -t my_session:0 'ssh alienware' C-m
sleep 0.5
tmux send-keys -t my_session:0 'tmux attach' C-m


# Allow some time for SSH to connect
sleep 4

# Enter copy mode
tmux send-keys -t my_session:0.1 C-a [
sleep 0.5

# Enter copy mode with Space
tmux send-keys -t my_session:0.1 Space
sleep 0.5

# Move up one line (assuming Vim bindings)
tmux send-keys -t my_session:0.1 k
sleep 0.5
tmux send-keys -t my_session:0.1 k
sleep 0.5
tmux send-keys -t my_session:0.1 k
sleep 0.5
tmux send-keys -t my_session:0.1 k
sleep 0.5

# Press Return to copy text
tmux send-keys -t my_session:0.1 C-m

# test oscyank via vim, change pane
sleep 0.5
tmux send-keys -t my_session:0.1 C-a C-j
sleep 0.5
tmux send-keys -t my_session:0.1 y
sleep 0.5
tmux send-keys -t my_session:0.1 y
sleep 0.5
tmux send-keys -t my_session:0.1 C-a C-k
sleep 0.5


# ---------- Second target
# Enter copy mode on second
sleep 0.5
tmux send-keys -t my_session:0.2 C-a [

# Enter copy mode with Space
tmux send-keys -t my_session:0.2 Space
sleep 0.5

# Move up one line (assuming Vim bindings)
tmux send-keys -t my_session:0.2 k
sleep 0.5
tmux send-keys -t my_session:0.2 k
sleep 0.5
tmux send-keys -t my_session:0.2 k
sleep 0.5
tmux send-keys -t my_session:0.2 k
sleep 0.5

# Press Return to copy text
tmux send-keys -t my_session:0.2 C-m

# test oscyank via vim, change pane
sleep 0.5
tmux send-keys -t my_session:0.2 C-a C-j
sleep 0.5
tmux send-keys -t my_session:0.2 y
sleep 0.5
tmux send-keys -t my_session:0.2 y
sleep 0.5
tmux send-keys -t my_session:0.2 C-a C-k

# Wait for the background tmux process to finish before exiting the script
wait $TMUX_PID
