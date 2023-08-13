#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Samsung Motion photo split
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "remote path" }

# Documentation:
# @raycast.author Charles


# rsync -avz --remove-source-files alienware:$1 /Users/cc/Desktop
# rsync -avz alienware:$1 /Users/cc/Desktop
for file_path in "$@"; do
    ~/anaconda3/bin/python ~/bin/samsung_motion_photo_splitter.py "$file_path"
    ~/bin/tselect ~/Desktop/$(basename -- "$file_path" .jpg)_extracted_motion.mp4
done

