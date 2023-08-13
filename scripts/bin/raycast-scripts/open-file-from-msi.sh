#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open file from MSI
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# i removed this @raycast.argument1 { "type": "text", "placeholder": "remote path" }

# Documentation:
# @raycast.author Charles

# rsync -avz --remove-source-files msi:$1 /Users/cc/Desktop
# rsync -avz msi:$1 /Users/cc/Desktop
while IFS= read -r line; do
    file_path=$line
    escaped_file_path=$(echo $file_path | sed 's/ /\\ /g')
    echo $escaped_file_path
    rsync -avz msi:"$escaped_file_path" /Users/cc/Desktop
    open ~/Desktop/$( basename "$file_path" )
done <<< "$(pbpaste)"
