sudo pacman --needed -Syu yay

yay --noconfirm --needed --answerclean None -S firefox neovim zsh tmux inkscape i3status-rust libinput-gestures maim teams discord nerd-fonts-source-code-pro wmctrl xdotool rofi rofimoji alttab-git tmuxinator texlive-core dolphin dolphin-plugins ark cheese playerctl yarn redshift kcolorchooser darktable konsole kolourpaint pacdep discover flatpak packagekit-qt5 ttf-font-awesome dust mpd rofi-calc rclone synology-drive stow handlr-bin tig noto-fonts-emoji ktorrent solaar rofi-greenclip zathura zathura-pdf-mupdf zathura-djvu zathura-cb nomacs okular cmatrix bat exa neofetch xorg-xev krename btop kget lutris obs-studio the_silver_searcher steam-manjaro wine nodejs npm alacritty notion-app ripgrep github-cli

echo 'AUR packages'
yay --needed --answerclean None -S google-chrome spotify firefox-pwa imagej zoom betterlockscreen

sudo pacman --needed -S texlive-most


echo 'linking for snap -- assuming installed'
# pamac install snapd libpamac-snap-plugin
# sudo systemctl enable --now snapd.socket
# pamac install discover-snap
sudo ln -s /var/lib/snapd/snap /snap
