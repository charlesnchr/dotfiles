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
    sed -i 's|^import = .*|import = [ "~/.config/alacritty/themes/themes/tokyo-night-storm.toml" ]|' ~/.config/alacritty/alacritty.toml
    lookandfeeltool -a org.kde.breezedark.desktop
    echo "1" > ~/dotfiles/is_dark_mode  # Update the mode in the file
else
    # Currently in dark mode, so switch to light mode
    sed -i 's|^import = .*|import = [ "~/.config/alacritty/themes/themes/alabaster.toml" ]|' ~/.config/alacritty/alacritty.toml
    lookandfeeltool -a org.kde.breeze.desktop
    echo "0" > ~/dotfiles/is_dark_mode  # Update the mode in the file
fi
