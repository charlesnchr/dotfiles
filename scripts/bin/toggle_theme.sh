#!/bin/bash
: ' ----------------------------------------
* Creation Time : Sat 02 Sep 2023 20:55:01 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# Read the value from is_dark_mode file
current_mode=$(cat ~/dotfiles/is_dark_mode)

if [[ "$current_mode" == "0" ]]; then
    # Currently in light mode, so switch to dark mode
    sed -i 's/^colors:.*$/colors: \*tokyo-night/' ~/.config/alacritty/alacritty.yml
    lookandfeeltool -a org.manjaro.breath-dark.desktop
    echo "1" > ~/dotfiles/is_dark_mode  # Update the mode in the file
else
    # Currently in dark mode, so switch to light mode
    sed -i 's/^colors:.*$/colors: \*rose-pine-dawn/' ~/.config/alacritty/alacritty.yml
    lookandfeeltool -a org.manjaro.breath-light.desktop
    echo "0" > ~/dotfiles/is_dark_mode  # Update the mode in the file
fi
