#!/bin/bash

source ~/dotfiles/ask.sh

sudo pacman --needed -Syu yay base-devel

PACKAGES=$(cat <<-END
    neovim
    zsh
    tmux
    fzf
    tree
    fd
    ranger
    ctags
    ttf-sourcecodepro-nerd
    tmuxinator
    playerctl
    yarn
    dust
    rclone
    stow
    handlr-bin
    tig
    ktorrent
    solaar
    nomacs
    bat
    exa
    neofetch
    xorg-xev
    btop
    the_silver_searcher
    nvm
    alacritty
    ripgrep
    github-cli
    sshpass
    jq
END
)
echo -e "Official packages: $PACKAGES"
if ask "Install official packackes" Y; then
        yay --noconfirm --needed --answerclean None -S $PACKAGES
fi


AUR_packages=$(cat <<-END
    zoom
END
)
echo -e "AUR packages: $AUR_packages"

if ask "Install AUR packages" N; then
    yay --needed --answerclean None -S $AUR_packages
fi

if ask "Install flatpak packages" N; then
    cat arch/flatpak-packages.txt | xargs flatpak install -y
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

    # scientific packages
    pip install scikit-image numpy matplotlib opencv-python pandas
    # system and utility
    pip install pyudev
fi

if ask "Set up Github cli" Y; then
    gh config set -h github.com git_protocol ssh
fi

if ask "Set up laptop power settings" N; then
    xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch -s false
fi

if ask "Run general install script now?" Y; then
    bash ~/dotfiles/install.sh
fi

echo "Install e.g. Teams via Flathub/Discover"

# for laptop
echo "for laptop: fix the idle vs deep sleep kernel parameter, see arch wiki"

if ask "Run general install script now?" Y; then
    bash ~/dotfiles/install.sh
fi

if ask "Configure libinput-gestures" N; then
    # extra
    sudo gpasswd -a $USER input
    echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh
fi


if ask "Configure redshift" N; then
    echo "[redshift]
    allowed=true
    system=false
    users=" | sudo tee -a /etc/geoclue/geoclue.conf
fi


