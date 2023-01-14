#!/bin/bash

source ~/dotfiles/ask.sh

if ask "Install conda" Y; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
    bash ~/anaconda.sh -b -p $HOME/anaconda3
fi

if ask "Install node/nvim without sudo" Y; then
    # Node
    # Ref: https://johnpapa.net/node-and-npm-without-sudo/
    wget https://nodejs.org/dist/v14.15.4/node-v14.15.4-linux-x64.tar.xz
    mkdir -p $HOME/tools
    mkdir -p $HOME/bin
    # extract node to a custom directory, the directory should exist.
    tar xvf node-v14.15.4-linux-x64.tar.xz --directory=$HOME/tools
    ln -sf $HOME/tools/node-v14.15.4-linux-x64/bin/npm $HOME/bin/npm
    ln -sf $HOME/tools/node-v14.15.4-linux-x64/bin/npx $HOME/bin/npx
    ln -sf $HOME/tools/node-v14.15.4-linux-x64/bin/node $HOME/bin/node

    # Nvim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    mkdir -p ~/bin
    mv ./nvim.appimage ~/bin/nvim

    # zsh and tmux
    conda install -y -c conda-forge zsh tmux

    # other packages
    conda install -c conda-forge ripgrep
fi

if ask "zsh, tmux, nvim, node and python must be install. Continue?" Y; then
    # pass
    echo "Assuming zsh, tmux, nvim, node and python are installed"
else
    exit 1
fi

# load conda
source ~/anaconda3/etc/profile.d/conda.sh
conda activate base


# Install CLI tools and env
# Requirements
# - zsh
# - tmux
# - nvim
# - node
# - python

if ask "Install autojump, fzf, tmux plugin manager, fd-find and antigen"; then

    # autojump
    git clone https://github.com/wting/autojump.git ~/autojump
    cd ~/autojump
    ./install.py

    # fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all

    # tmux plugin manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins

    # fd-find
    npm install -g fd-find

    # antigen download
    mkdir -p $HOME/tools
    git clone https://github.com/zsh-users/antigen.git $HOME/tools/antigen
    zsh -ic "source ~/dotfiles/home_folder/.zshrc && source ~/tools/antigen/bin/antigen.zsh && antigen update"
fi


# NVIM
if ask "Set up nvim plugins etc." Y; then
    # vim plug
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    pip install -U pynvim
    nvim +'PlugInstall --sync' +qa
    nvim +'LspInstall vimls pylsp jsonls rust_analyzer'
fi

if ask "Install conda utilities (rclone, ripgrep, ctags)" Y; then
    conda install -y -c conda-forge universal-ctags rclone ripgrep
fi

if ask "Install pip utilities (ranger, skimage, numpy)" Y; then
    pip install ranger-fm scikit-image numpy matplotlib opencv-python
fi




# Setting up symlinks with stow or ln

# alternative, less clean, syntax:
# stow -R .config -t ~/.config

dirname=conf_bk_$(date '+%d%m%Y%H%M%S');

function move_if() {
    echo "moving $1"
    mv $1 $dirname
}

if ask "Move existing .profile, .zshrc, dunstrc, mimeapps.list, nvim to a folder named $dirname?" Y; then
    mkdir -p $dirname
    move_if ~/.profile
    move_if ~/.zshrc
    move_if ~/.spacemacs
    move_if ~/.tmux.conf
    move_if ~/.vimrc
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
else
    echo "Not moving existing files"
fi

# setting up links
if ask "Use stow to set up links" Y; then

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

else
    if ask "Use reduced symlink setup instead" Y; then
        ln -sfn ~/dotfiles/home_folder/.profile ~/.profile
        ln -sfn ~/dotfiles/home_folder/.zshrc ~/.zshrc
        ln -sfn ~/dotfiles/home_folder/.tmux.conf ~/.tmux.conf
        ln -sfn ~/dotfiles/home_folder/.vim ~/.vim
        ln -sfn ~/dotfiles/home_folder/.vimrc ~/.vimrc
        ln -sfn ~/dotfiles/nvim ~/.config/nvim
        ln -sfn ~/dotfiles/home_folder/.config/ranger ~/.config/ranger
        ln -sfn ~/dotfiles/home_folder/.tmux-cht-command ~/.tmux-cht-command
        ln -sfn ~/dotfiles/home_folder/.tmux-cht-languages ~/.tmux-cht-languages
        ln -sfn ~/dotfiles/scripts/bin ~/bin
    fi
fi

if ask "Set up submodule dotfiles_private and run dotfiles_private/install.sh?" N; then
    git submodule init dotfiles_private
    sh dotfiles_private/install.sh
fi

# Set up themes (for linux)
if ask "Set up themes?"; then

    # KDE theme
    if ask "Install kde theme"; then
        git clone https://github.com/tonyfettes/materia-nord-kvantum.git
        cd materia-nord-kvantum
        sudo mv Kvantum/MateriaNordDark /usr/share/Kvantum
    fi

    # GTK theme
    # https://github.com/EliverLara/Nordic
    # https://www.gnome-look.org/p/1267246/
    if ask "Install GTK theme"; then
        wget https://github.com/EliverLara/Nordic/releases/download/v2.1.0/Nordic-darker-v40.tar.xz
        tar xvf Nordic-darker-v40.tar.xz
        sudo mv Nordic-darker-v40 /usr/share/themes
        gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
        gsettings set org.gnome.desktop.wm.preferences theme "Nordic"
    fi


    echo "now use lxappearance and kvantum to set themes"
fi

