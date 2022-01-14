#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install zsh
brew install neovim nodejs
brew install universal-ctags

# conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
bash ~/anaconda.sh -b -p $HOME/anaconda3

source ~/anaconda3/etc/profile.d/conda.sh
conda install -c conda-forge rclone

chsh -s /usr/local/bin/zsh
