#!/bin/bash
: ' ----------------------------------------
* Creation Time : Wed 23 Aug 2023 00:15:11 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# mount Synology server if not already mounted
if ! mountpoint -q /media/video; then
  sshfs radian-local:video /media/video
fi

# Set video folder
dir="/media/video/dokumentarer/5 Attenborough"

# Get list of videos recursively into associative array
declare -A videos
index=0
while IFS= read -r -d '' file; do
  videos[$index]="$file"
  index=$((index+1))
done < <(find "$dir" -type f -iname "*.mp4" -or -iname "*.avi" -or -iname "*.mkv" -print0)

# Loop variables
done=0
exit_code=0

# Get list of videos into associative array
# (same as previous script...)

# Play random videos until 'q' is pressed
while [ $done -eq 0 ]; do

  # Pick random video
  index=$((RANDOM % ${#videos[@]}))
  video=${videos[$index]}

  # Play video
  mplayer -subfont-osd-scale 2 -subfont-text-scale 2 "$video"
  exit_code=$?

  # Check if 'q' is pressed
  read -n1 -t 0.1 key
  if [ "$key" = 'q' ]; then
    done=1
  fi

  # Handle exit
  if [ $exit_code -ne 0 ]; then
    echo "mplayer exited, playing another"
  fi

done

echo "Quitting"
