#!/bin/bash

# alternative, less clean, syntax:
# stow -R .config -t ~/.config

dirname=conf_bk_$(date '+%d%m%Y%H%M%S');

echo "Move existing .profile, .zshrc, dunstrc, mimeapps.list, nvim to a folder named $dirname?"
select yn in "Yes" "No"; do
  case $yn in
    Yes )
        mkdir -p $dirname
        mv ~/.profile $dirname
        mv ~/.zshrc $dirname
        mv ~/.config/dunst $dirname
        mv ~/.config/mimeapps.list $dirname
        mv ~/.config/libinput-gestures.conf $dirname
        mv ~/.config/nvim $dirname
        mv ~/.config/rofi $dirname
        mv ~/.config/alacritty $dirname
        mv ~/bin/i3exit $dirname
        [ -f ~/.screenlayout ] && mv ~/.screenlayout $dirname
        mv ~/.config/picom.conf $dirname
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
stow alacritty
stow mime-settings
