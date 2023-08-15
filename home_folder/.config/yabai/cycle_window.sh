#!/bin/bash
: ' ----------------------------------------
* Creation Time : Mon May  2 14:03:41 2022
* Last Modified : Mon May  2 22:29:59 2022
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

#!/bin/bash

# Arguments:
# $1: 0/1 = next/prev (left/right for x_dir or up/down for y_dir)
# $2: x_dir/y_dir

# Get all windows for the current space
windows=$(yabai -m query --windows --space)

# Get the currently focused window's data
current=$(yabai -m query --windows --window)

# Pipe the data into Python for processing
target_id=$(python3 - <<END
import json
import sys

windows = json.loads('''$windows''')
current = json.loads('''$current''')

direction = "$2"
direction_val = int("$1")

# Extract borders and center
left_border = current['frame']['x']
right_border = left_border + current['frame']['w']
top_border = current['frame']['y']
bottom_border = top_border + current['frame']['h']
center_x = (left_border + right_border) / 2
center_y = (top_border + bottom_border) / 2

def distance(window, dir):
    w_left = window['frame']['x']
    w_right = w_left + window['frame']['w']
    w_top = window['frame']['y']
    w_bottom = w_top + window['frame']['h']
    w_center_x = (w_left + w_right) / 2
    w_center_y = (w_top + w_bottom) / 2

    if dir == 'x_dir':
        primary_distance = w_left - right_border if direction_val == 0 else left_border - w_right
        secondary_distance = abs(w_center_y - center_y)
    else:
        primary_distance = w_top - bottom_border if direction_val == 0 else top_border - w_bottom
        secondary_distance = abs(w_center_x - center_x)

    # We use a tuple to prioritize primary distance, but still consider secondary distance
    return (primary_distance if primary_distance > 0 else float('inf'), secondary_distance)

# Exclude the current window from the windows list
windows = [w for w in windows if w['id'] != current['id']]

# Find the nearest window in the specified direction
nearest = min(windows, key=lambda w: distance(w, direction), default=None)

if nearest:
    print(nearest['id'])
else:
    print("")
END
)

# Focus the target window, if we found one
if [[ -n "$target_id" ]]; then
    yabai -m window --focus "$target_id"
fi
