#!/bin/bash

source ~/dotfiles/ask.sh

sudo pacman --needed -Syu yay


PACKAGES=$(cat <<-END
    firefox
    neovim
    zsh
    tmux
    manjaro-pulse
    pavucontrol
    inkscape
    i3status-rust
    libinput-gestures
    maim
    discord
    nerd-fonts-source-code-pro
    wmctrl
    xdotool
    rofi
    rofimoji
    tmuxinator
    texlive-core
    dolphin
    dolphin-plugins
    ark
    cheese
    playerctl
    yarn
    redshift
    kcolorchooser
    darktable
    konsole
    kolourpaint
    pacdep
    discover
    flatpak
    packagekit-qt5
    ttf-font-awesome
    dust
    mpd
    rofi-calc
    qalculate-qt
    rclone
    stow
    handlr-bin
    tig
    noto-fonts-emoji
    font-manager
    ktorrent
    solaar
    rofi-greenclip
    zathura
    zathura-pdf-mupdf
    zathura-djvu
    zathura-cb
    nomacs
    okular
    cmatrix
    bat
    exa
    neofetch
    xorg-xev
    krename
    btop
    kget
    lutris
    obs-studio
    the_silver_searcher
    steam-manjaro
    wine
    nodejs
    npm
    alacritty
    ripgrep
    github-cli
    kmix
    copyq
    sshpass
    xcape
    audacity
    jq
    unclutter
    ueberzug
    autorandr
    xfce4-settings
    xfce4-settings-gtk3
    neomutt
    syncthing
    urlscan
END
)
echo -e "Official packages: $PACKAGES"
if ask "Install official packackes" Y; then
        yay --noconfirm --needed --answerclean None -S $PACKAGES
fi


AUR_packages=$(cat <<-END
    google-chrome
    spotify
    firefox-pwa
    imagej
    zoom
    betterlockscreen
    logiops-git
    alttab-git
    notion-app
    synology-drive
    signal-desktop-beta-bin
    orage
END
)
echo -e "AUR packages: $AUR_packages"

if ask "Install AUR packages" N; then
    yay --needed --answerclean None -S $AUR_packages
fi

if ask "kmonad" N; then
    yay --needed -S kmonad-bin
fi

if ask "Full texlive install" N; then
    sudo pacman --needed -S texlive-most
fi

if ask "Conda env install" N; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
    bash ~/anaconda.sh -b -p $HOME/anaconda3
fi

if ask "Python packages" Y; then

    source ~/anaconda3/etc/profile.d/conda.sh
    conda activate base

    conda install -y -c conda-forge universal-ctags
    # scientific packages
    pip install ranger scikit-image numpy matplotlib opencv-python pandas
    # system and utility
    pip install pyudev i3-balance-workspace
fi

SNAP_packages="code"
if ask "Install snapd and link"; then
    echo 'linking for snap -- assuming installed'
    # pamac install snapd libpamac-snap-plugin
    # sudo systemctl enable --now snapd.socket
    # pamac install discover-snap
    sudo ln -s /var/lib/snapd/snap /snap
fi

if ask "Install snap packages"; then
    sudo snap install $SNAP_packages
fi

if ask "Set up Github cli" Y; then
    gh config set -h github.com git_protocol ssh
fi


if ask "Set up laptop power settings" N; then
    xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch -s false
fi


if ask "Activate betterlockscreen" Y; then
    xfconf-query -c xfce4-session -p /general/LockCommand -s "betterlockscreen -l" -n -t string
fi


echo "Install e.g. Teams via Flathub/Discover"
