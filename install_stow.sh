#!/bin/bash

# alternative, less clean, syntax:
# stow -R .config -t ~/.config

dirname=conf_bk_$(date '+%d%m%Y%H%M%S');

function move_if() {
    echo "moving $1"
    mv $1 $dirname
}

echo "Move existing .profile, .zshrc, dunstrc, mimeapps.list, nvim to a folder named $dirname?"
select yn in "Yes" "No"; do
  case $yn in
    Yes )
        mkdir -p $dirname
        move_if ~/.profile
        move_if ~/.zshrc
        move_if ~/.config/dunst
        move_if ~/.config/mimeapps.list
        move_if ~/.config/libinput-gestures.conf
        move_if ~/.config/nvim
        move_if ~/.config/rofi
        move_if ~/.config/alacritty
        move_if ~/bin/i3exit
        move_if ~/.screenlayout
        move_if ~/.config/ranger/plugins/autojump.py
        move_if ~/.config/ranger/rc.conf
        move_if ~/.config/ranger/rifle.conf
        move_if ~/.config/picom.conf
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
