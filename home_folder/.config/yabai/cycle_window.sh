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

open('/Users/cnc40853/Desktop/log.txt', 'a').write('\n\n')

windows = json.loads('''$windows''')
current = json.loads('''$current''')

direction_val = int("$1")
dir = "$2"

# Extract borders and center
left_border = current['frame']['x']
right_border = left_border + current['frame']['w']
top_border = current['frame']['y']
bottom_border = top_border + current['frame']['h']
center_x = (left_border + right_border) / 2
center_y = (top_border + bottom_border) / 2

def distance(window):
    w_left = window['frame']['x']
    w_right = w_left + window['frame']['w']
    w_top = window['frame']['y']
    w_bottom = w_top + window['frame']['h']
    w_center_x = (w_left + w_right) / 2
    w_center_y = (w_top + w_bottom) / 2

    if dir == 'x_dir':
        if direction_val == 1:
            primary_distance = left_border - w_left
        else:
            primary_distance = w_right - right_border
    else:
        if direction_val == 1:
            primary_distance = top_border - w_top
        else:
            primary_distance = w_bottom - bottom_border


    # print every single parameters with format PARAM: VALUE
    open('/Users/cnc40853/Desktop/log.txt', 'a').write(f'w_left: {w_left} w_right: {w_right} w_top: {w_top} w_bottom: {w_bottom} w_center_x: {w_center_x} w_center_y: {w_center_y} primary_distance: {primary_distance}\n')
    open('/Users/cnc40853/Desktop/log.txt', 'a').write(f'left_border: {left_border} right_border: {right_border} top_border: {top_border} bottom_border: {bottom_border} center_x: {center_x} center_y: {center_y}\n')

    if primary_distance > 0:
        return primary_distance
    else:
        return 10000

# Exclude the current window and ones not in the desired direction from the windows list
windows = [w for w in windows if w['id'] != current['id']]

# Find the nearest window in the specified direction
min_distance = 10000
nearest = None
for window in windows:
    d = distance(window)
    open('/Users/cnc40853/Desktop/log.txt', 'a').write(f'{d}\n')
    if d is not None and d < min_distance and d > 0:
        min_distance = d
        nearest = window

if nearest is not None:
    open('/Users/cnc40853/Desktop/log.txt', 'a').write(f'{nearest["id"]}\n')
else:
    open('/Users/cnc40853/Desktop/log.txt', 'a').write(f'None\n')

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
