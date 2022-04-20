#!/bin/bash
: ' ----------------------------------------
* Creation Time : Tue 19 Apr 2022 13:02:00 BST
* Last Modified : Tue 19 Apr 2022 13:27:14 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

PROMPT=$1

# Confirmation Dialog
confirmation() {
    echo -e "y\nn" | rofi -dmenu -selected-row 0 -no-fixed-num-lines -theme $HOME/.config/rofi/dmenu_cc_confirm.rasi -auto-select -p "$PROMPT  (y/n)"
}

choice=$(confirmation &)

case $choice in
  y)
      echo $2
      eval $2
      ;;
  n) exit 0 ;;
esac

