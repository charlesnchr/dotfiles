#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
bash ~/anaconda.sh -b -p $HOME/anaconda3
source ~/anaconda3/etc/profile.d/conda.sh
conda activate base

conda install -y -c conda-forge zsh universal-ctags rclone tmux
pip install ranger scikit-image numpy matplotlib opencv-python

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


