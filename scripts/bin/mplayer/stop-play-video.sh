#!/bin/bash
: ' ----------------------------------------
* Creation Time : Wed 23 Aug 2023 00:47:41 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# Check if the session named 'mplayer' exists
tmux has-session -t mplayer 2>/dev/null

if [ $? = 0 ]; then
  # Kill the session named 'mplayer'
  tmux kill-session -t mplayer
  echo "Killed tmux session named 'mplayer'"
else
  echo "No tmux session named 'mplayer' found"
fi


