#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Get files from nfp
# @raycast.mode inline

# Documentation:
# @raycast.author Charles


# rsync -avz --remove-source-files alienware:$1 /Users/cc/Desktop
# rsync -avz alienware:$1 /Users/cc/Desktop

while IFS= read -r line; do
    file_path=$line
    escaped_file_path=$(echo $file_path | sed 's/ /\\ /g')
    echo $escaped_file_path
    rsync -avz nfp:"$escaped_file_path" /Users/cc/Desktop
done <<< "$(pbpaste)"

