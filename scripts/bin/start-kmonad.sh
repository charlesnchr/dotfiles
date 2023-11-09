#!/bin/bash
: ' ----------------------------------------
* Creation Time : Thu 14 Sep 2023 22:47:20 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# Kill any running kmonad processes (exact match to avoid killing this script)
pkill -x kmonad

# Give the system a moment to actually kill the process
sleep 1

# Define the path to the config that will be used by KMonad
CONFIG="/home/cc/.config/lenovo-thinkpad.kbd"

# Start KMonad
kmonad "$CONFIG"
