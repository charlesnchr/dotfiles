#!/bin/bash
: ' ----------------------------------------
* Creation Time : Wed 23 Aug 2023 00:47:07 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# Check if the session named 'mplayer' already exists
tmux has-session -t mplayer 2>/dev/null

# $? is a special variable that holds the exit status of the last command executed
if [ $? != 0 ]; then
  # Create a new session named 'mplayer', detached (-d) and run your script
  tmux new-session -d -s mplayer "bash /home/cc/bin/mplayer/play-video.sh"
  echo "Started MPlayer in tmux session named 'mplayer'"
else
  echo "A tmux session named 'mplayer' is already running"
fi


