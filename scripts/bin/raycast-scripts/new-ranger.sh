#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title new ranger
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description creates brave window
# @raycast.author Charles

open -a Alacritty --args -e zsh -ic "cd ~/0main && ranger"
