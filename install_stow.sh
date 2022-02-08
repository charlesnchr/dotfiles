#!/bin/bash

# alternative, less clean, syntax:
# stow -R .config -t ~/.config

echo "Delete existing .profile, .zshrc, dunstrc, mimeapps.list?"
select yn in "Yes" "No"; do
  case $yn in
    Yes )
        rm ~/.profile
        rm ~/.zshrc
        rm -rf ~/.config/dunst
        rm ~/.config/mimeapps.list
        ;;
    No ) exit;;
  esac
done


stow home_folder
stow home_folder_desktop

stow nvim
stow ricing

stow i3

stow scripts
stow alacritty
stow mime-settings
