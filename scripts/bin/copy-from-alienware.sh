#!/bin/bash
: ' ----------------------------------------
* Creation Time : Mon 21 Aug 2023 17:13:28 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

#!/bin/bash

# Define a function for the main logic.
while IFS= read -r line; do
    file_path="$line"
    escaped_file_path=$(echo "$file_path" | sed 's/ /\\ /g')
    echo "$escaped_file_path"
    rsync -avz --progress alienware:"$escaped_file_path" /home/cc/Desktop
done <<< "$(wl-paste)"

