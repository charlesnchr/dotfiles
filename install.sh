#!/bin/bash

source ~/dotfiles/ask.sh

if ask "Install conda x86" N; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
    bash ~/anaconda.sh -b -p $HOME/anaconda3
fi

if ask "Install conda ARM" N; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/anaconda.sh
    bash ~/anaconda.sh -b -p $HOME/anaconda3
fi

if ask "Install conda MacOSX" N; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/anaconda.sh
    bash ~/anaconda.sh -b -p $HOME/anaconda3
fi

if ask "Install node/nvim without sudo (curl and conda)" N; then
    # Node
    conda install -c conda-forge nodejs

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


if ask "Install git without sudo (in this case just conda)" N; then
    conda install -y git
fi


# pv required compression and backup scripts, sqlite3 required for histdb
if ask "Ubuntu: install essentials - zsh, tmux, nvim, node, git, ranger, pv, sqlite3?" N; then
    sudo apt install zsh tmux neovim nodejs ranger pv sqlite3 -y
fi


if ask "zsh, tmux, nvim, node, git and python must be installed. Continue?" Y; then
    :
else
    exit 1
fi


# load conda
echo "Loading conda"
source ~/anaconda3/etc/profile.d/conda.sh
conda activate base


# Install CLI tools and env
# Requirements
# - zsh
# - tmux
# - nvim
# - node
# - python


if ask "Install autojump and fzf from github" N; then
    # autojump
    git clone --depth 1 https://github.com/wting/autojump.git
    cd autojump
    ./install.py

    # fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi


# Setting up symlinks with stow or ln

if ask "stow is recommended in the following. Install on Ubuntu?" N; then
    sudo apt install stow -y
fi

# alternative, less clean, syntax:
# stow -R .config -t ~/.config

dirname=conf_bk_$(date '+%d%m%Y%H%M%S');

function move_if() {
    echo "moving $1"
    mv $1 $dirname
}

if ask "Move existing .profile, .zshrc, nvim to a folder named $dirname?" N; then
    mkdir -p $dirname
    move_if ~/.profile
    move_if ~/.zshrc
    move_if ~/.tmux.conf
    move_if ~/.vimrc
    move_if ~/.config/nvim
    move_if ~/.config/alacritty
    move_if ~/.config/ranger
    move_if ~/.config/dolphinrc
    move_if ~/.config/kdeglobals
    move_if ~/.config/konsolerc
    move_if ~/.config/kwinrc
    move_if ~/.config/plasma-org.kde.plasma.desktop-appletsrc
    move_if ~/.config/plasmarc
    move_if ~/.config/plasmashellrc
else
    echo "Not moving existing files"
fi

# setting up links
if ask "Use stow to set up links" N; then

    stow home_folder
    mkdir -p ../bin
    stow scripts
    stow nvim

    echo "Select extra config"
    select yn in "Desktop" "Laptop" "No"; do
      case $yn in
        Desktop )
            stow home_folder_desktop
            break
            ;;
        Laptop )
            stow home_folder_laptop
            break
            ;;
        No )
            break
            ;;
      esac
    done
else
    if ask "Use reduced symlink setup instead" N; then
        ln -sfn ~/dotfiles/home_folder/.profile ~/.profile
        ln -sfn ~/dotfiles/home_folder/.zshrc ~/.zshrc
        ln -sfn ~/dotfiles/home_folder/.tmux.conf ~/.tmux.conf
        ln -sfn ~/dotfiles/home_folder/.vim ~/.vim
        ln -sfn ~/dotfiles/home_folder/.vimrc ~/.vimrc
        ln -sfn ~/dotfiles/nvim/.config/nvim ~/.config/nvim
        ln -sfn ~/dotfiles/home_folder/.config/ranger ~/.config/ranger
        ln -sfn ~/dotfiles/home_folder/.tmux-cht-command ~/.tmux-cht-command
        ln -sfn ~/dotfiles/home_folder/.tmux-cht-languages ~/.tmux-cht-languages
        ln -sfn ~/dotfiles/scripts/bin ~/bin
    fi
fi

if ask "Set up submodule dotfiles_private and run dotfiles_private/install.sh?" N; then
    git submodule init dotfiles_private
    git pull --recurse-submodules
    sh dotfiles_private/install.sh
fi

# Set up themes (for linux)
if ask "Linux desktop: Set up themes?" N; then

    # KDE theme
    if ask "Install kde theme" N; then
        git clone https://github.com/tonyfettes/materia-nord-kvantum.git
        cd materia-nord-kvantum
        sudo mv Kvantum/MateriaNordDark /usr/share/Kvantum
    fi

    # GTK theme
    # https://github.com/EliverLara/Nordic
    # https://www.gnome-look.org/p/1267246/
    if ask "Install GTK theme" N; then
        wget https://github.com/EliverLara/Nordic/releases/download/v2.1.0/Nordic-darker-v40.tar.xz
        tar xvf Nordic-darker-v40.tar.xz
        sudo mv Nordic-darker-v40 /usr/share/themes
        gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
        gsettings set org.gnome.desktop.wm.preferences theme "Nordic"
    fi


    echo "now use lxappearance and kvantum to set themes"
fi


# NVIM
if ask "Set up nvim plugins etc." N; then
    # vim plug
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    pip install -U pynvim
    nvim +'PlugInstall --sync' +qa
    nvim +'MasonInstall vim-language-server json-lsp rust-analyzer'
fi



if ask "Install tmux plugin manager and antidote" N; then
    # tmux plugin manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins

    # antidote download
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote

    zsh -ic "source ~/dotfiles/home_folder/.zshrc && source ~/.antidote/antidote.zsh && antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
fi

if ask "Ubuntu: Install rclone, ripgrep, ctags" N; then
    sudo apt install universal-ctags rclone ripgrep -y
else
    if ask "Conda: Install rclone, ripgrep, ctags" N; then
        conda install -y -c conda-forge universal-ctags rclone ripgrep
    fi
fi

if ask "Install pylsp and scientific python packages (skimage, numpy, pylsp, streamlit)" N; then
    pip install scikit-image numpy matplotlib python-lsp-server[all] ruff python-lsp-ruff streamlit
fi
