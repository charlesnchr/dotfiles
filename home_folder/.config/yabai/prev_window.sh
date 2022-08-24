#!/bin/bash
: ' ----------------------------------------
* Creation Time : Mon May  2 14:03:41 2022
* Last Modified : Mon May  2 16:03:59 2022
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

IDS=($(yabai -m query --spaces --space \
  | jq -re ".index" \
  | xargs -I{} yabai -m query --windows --space {} | jq '.[] | .id'))

echo $IDS

CUR_IDX=$(yabai -m query --spaces --space \
  | jq -re ".index" \
  | xargs -I{} yabai -m query --windows --space {} \
  | jq -sre 'add | map(select(."is-minimized"==false)) | . as $array | length as $array_length | map(select(."has-focus"==true)) | .[] | .id')

echo $CUR_IDX

NEW_IDX=0
len=${#IDS[@]}

for i in "${!IDS[@]}"; do
   if [[ "${IDS[$i]}" = "$CUR_IDX" ]]; then
       NEW_IDX=$(( $i + 1 ))
       if (( $NEW_IDX >= len )); then
           NEW_IDX=0
       fi
       break;
   fi
done

NEW_ID=${IDS[$NEW_IDX]}

yabai -m window --focus $NEW_ID
