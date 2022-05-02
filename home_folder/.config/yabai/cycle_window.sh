#!/bin/bash
: ' ----------------------------------------
* Creation Time : Mon May  2 14:03:41 2022
* Last Modified : Mon May  2 22:29:59 2022
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# Arguments:
## $1: 0/1 = next/prev
## $2: x_dir/y_dir
## $3: 0/1 = circular boundary

if [ "$2" = "x_dir" ]; then
    IDS=($(yabai -m query --spaces --space \
      | jq -re ".index" \
      | xargs -I{} yabai -m query --windows --space {} | jq 'sort_by(.frame.x) | .[] | .id'))

    # /usr/bin/env osascript <<< \
    #     "display notification \"x dir\" with title \"Yabai\"";
else
    IDS=($(yabai -m query --spaces --space \
      | jq -re ".index" \
      | xargs -I{} yabai -m query --windows --space {} | jq 'sort_by(.frame.y) | .[] | .id'))

    # /usr/bin/env osascript <<< \
    #     "display notification \"y dir\" with title \"Yabai\"";
fi

# IDS=($(yabai -m query --spaces --space \
#   | jq -re ".index" \
#   | xargs -I{} yabai -m query --windows --space {} | jq 'sort_by(.id) | .[] | .id'))

# echo "${IDS[@]}"

CUR_ID=$(yabai -m query --spaces --space \
  | jq -re ".index" \
  | xargs -I{} yabai -m query --windows --space {} \
  | jq -sre 'add | map(select(."is-minimized"==false)) | . as $array | length as $array_length | map(select(."has-focus"==true)) | .[] | .id')

# echo "cur idx " $CUR_ID

NEW_IDX=0
len=${#IDS[@]}

for i in "${!IDS[@]}"; do
   if [[ "${IDS[$i]}" = "$CUR_ID" ]]; then
       if [ $1 -eq 0 ]; then
           # echo "next "
           NEW_IDX=$(( $i + 1 ))
           if (( $NEW_IDX >= len )); then
               if [ $3 -eq 0 ]; then
                   NEW_IDX=0
               else
                   NEW_IDX = $len
               fi
           fi
       else
           # echo "prev "
           NEW_IDX=$(( $i - 1 ))
           if (( $NEW_IDX < 0 )); then
               if [ $3 -eq 0 ]; then
                   NEW_IDX=$(( $len-1 ))
               else
                   NEW_IDX = 0
               fi
           fi
       fi
       break;
   fi
done

NEW_ID=${IDS[$NEW_IDX]}
# echo "new id " $NEW_ID

yabai -m window --focus $NEW_ID


# different syntax
# yabai -m window --focus "$(yabai -m query --windows | jq -re "sort_by(.display, .space, .frame.x, .frame.y, .id) | map(select(.subrole != \"AXUnknown\")) | reverse | nth(index(map(select(.focused == 1))) - 1).id")"
