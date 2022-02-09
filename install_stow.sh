#!/bin/bash

# alternative, less clean, syntax:
# stow -R .config -t ~/.config

echo "Move existing .profile, .zshrc, dunstrc, mimeapps.list, nvim to a folder named conf_bk?"
select yn in "Yes" "No"; do
  case $yn in
    Yes )
        mkdir -p conf_bk
        mv ~/.profile conf_bk
        mv ~/.zshrc conf_bk
        mv ~/.config/dunst conf_bk
        mv ~/.config/mimeapps.list conf_bk
        mv ~/.config/libinput-gestures.conf conf_bk
        mv ~/.config/nvim conf_bk
        mv ~/.config/rofi conf_bk
        mv ~/.config/alacritty conf_bk
        mv ~/bin/i3exit conf_bk
        break
        ;;
    No ) break;; #exit;;
  esac
done


stow home_folder
stow scripts
stow nvim


echo "Select extra config"
select yn in "Desktop" "Laptop" "Server" "None"; do
  case $yn in
    Desktop )
        stow home_folder_desktop
        break
        ;;
    Laptop )
        stow home_folder_laptop
        break
        ;;
    Server )
        exit
        ;;
    None )
        break
        ;;
  esac
done


stow ricing
stow i3
stow alacritty
stow mime-settings
