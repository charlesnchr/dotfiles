#!/bin/bash
sudo pacman --needed -Syu yay

yay --noconfirm --needed --answerclean None -S firefox neovim zsh tmux manjaro-pulse pavucontrol inkscape i3status-rust libinput-gestures maim teams discord nerd-fonts-source-code-pro wmctrl xdotool rofi rofimoji alttab-git tmuxinator texlive-core dolphin dolphin-plugins ark cheese playerctl yarn redshift kcolorchooser darktable konsole kolourpaint pacdep discover flatpak packagekit-qt5 ttf-font-awesome dust mpd rofi-calc rclone synology-drive stow handlr-bin tig noto-fonts-emoji ktorrent solaar rofi-greenclip zathura zathura-pdf-mupdf zathura-djvu zathura-cb nomacs okular cmatrix bat exa neofetch xorg-xev krename btop kget lutris obs-studio the_silver_searcher steam-manjaro wine nodejs npm alacritty notion-app ripgrep github-cli kmix copyq sshpass xcape

echo 'AUR packages'
yay --needed --answerclean None -S google-chrome spotify firefox-pwa imagej zoom betterlockscreen

sudo pacman --needed -S texlive-most


echo 'linking for snap -- assuming installed'
# pamac install snapd libpamac-snap-plugin
# sudo systemctl enable --now snapd.socket
# pamac install discover-snap
sudo ln -s /var/lib/snapd/snap /snap

echo 'setting up Github cli'
gh config set -h github.com git_protocol ssh

echo 'setting up power settings'

xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch -s false

xfconf-query -c xfce4-session -p /general/LockCommand -s betterlockscreen -l -n -t string
