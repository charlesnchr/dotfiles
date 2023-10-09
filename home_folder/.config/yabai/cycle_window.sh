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

def is_in_desired_direction(window, dir):
    w_left = window['frame']['x']
    w_right = w_left + window['frame']['w']
    w_top = window['frame']['y']
    w_bottom = w_top + window['frame']['h']

    if dir == 'x_dir':
        return (w_right > left_border and direction_val == 0) or (w_left < right_border and direction_val == 1)
    else:
        return (w_bottom > top_border and direction_val == 0) or (w_top < bottom_border and direction_val == 1)

def distance(window, dir):
    w_left = window['frame']['x']
    w_right = w_left + window['frame']['w']
    w_top = window['frame']['y']
    w_bottom = w_top + window['frame']['h']
    w_center_x = (w_left + w_right) / 2
    w_center_y = (w_top + w_bottom) / 2

    if dir == 'x_dir':
        if direction_val == 0:
            primary_distance = (w_left - right_border)
        else:
            primary_distance = (left_border - w_right)
        secondary_distance = (w_center_y - center_y)
    else:
        if direction_val == 0:
            primary_distance = (w_top - bottom_border)
        else:
            primary_distance = (top_border - w_bottom)
        secondary_distance = (w_center_x - center_x)

    # We use a tuple to prioritize primary distance, but still consider secondary distance

    if primary_distance > 0:
        return (primary_distance, secondary_distance)
    else:
        return (None, None)

# Exclude the current window and ones not in the desired direction from the windows list
windows = [w for w in windows if w['id'] != current['id'] and is_in_desired_direction(w, direction)]

# Find the nearest window in the specified direction
nearest = min(windows, key=lambda w: distance(w, direction), default=None)

if nearest is not None:
    print(nearest['id'])
else:
    print("")
END
)

# Focus the target window, if we found one
if [[ -n "$target_id" ]]; then
    yabai -m window --focus "$target_id"
fi
