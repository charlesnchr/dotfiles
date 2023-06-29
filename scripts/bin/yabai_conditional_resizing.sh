#!/bin/bash
: ' ----------------------------------------
* Creation Time : Fri Apr 21 16:26:22 2023
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

## Convoluted method
# # Get the ID of the current space
# current_space_id=$(yabai -m query --spaces --space | jq '.index')

# # Query active windows using Yabai and filter based on the current space
# window_count=$(yabai -m query --windows | jq --arg current_space_id "$current_space_id" 'map(select(.space == ($current_space_id | tonumber)).app) | length')

## Easier method
windows=$(yabai -m query --windows --space | jq -r '.[].id')
window_count=${#windows[@]}

echo "Unique active apps in the current space: $active_apps"

yabai -m space --balance; yabai -m window --swap largest; yabai -m window --resize bottom:0:350; yabai -m window --resize top:0:350; yabai -m window --resize right:450:0; yabai -m window --resize left:450:0

# Conditional action based on the number of active apps
#

# if [ "$window_count" -lt 3 ]; then
#     yabai -m space --balance; yabai -m window --swap largest; yabai -m window --resize bottom:0:350; yabai -m window --resize top:0:350; yabai -m window --resize right:450:0; yabai -m window --resize left:450:0
# fi

# if [ "$window_count" -eq 3 ]; then
#     yabai -m space --balance; yabai -m window --swap largest; yabai -m window --resize bottom:0:350; yabai -m window --resize top:0:350; yabai -m window --resize right:450:0; yabai -m window --resize left:450:0
# fi

# if [ "$window_count" -eq 4 ]; then
#  jq ".[] | select(.space == $current_space_id)"
#    yabai -m space --balance; yabai -m window --swap largest; yabai -m window --resize bottom:0:350; yabai -m window --resize top:0:350; yabai -m window --resize right:450:0; yabai -m window --resize left:450:0
# fi

# if [ "$window_count" -eq 5 ]; then
#   echo "4"
# fi

# if [ "$window_count" -eq 6 ]; then
#   echo "4"
# fi

# if [ "$window_count" -eq 7 ]; then
#   echo "4"
# fi
