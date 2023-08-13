#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open file from Alienware
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# i removed this @raycast.argument1 { "type": "text", "placeholder": "remote path" }

# Documentation:
# @raycast.author Charles

# rsync -avz --remove-source-files alienware:$1 /Users/cc/Desktop
# rsync -avz alienware:$1 /Users/cc/Desktop
while IFS= read -r line; do
    file_path=$line
    escaped_file_path=$(echo $file_path | sed 's/ /\\ /g')
    echo $escaped_file_path
    rsync -avz alienware:"$escaped_file_path" /Users/cc/Desktop
    open ~/Desktop/$( basename "$file_path" )
done <<< "$(pbpaste)"
