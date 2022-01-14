#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
bash ~/anaconda.sh -b -p $HOME/anaconda3
source ~/anaconda3/etc/profile.d/conda.sh

conda install -c conda-forge zsh
conda install -c conda-forge universal-ctags
conda install -c conda-forge rclone

# Node
# Ref: https://johnpapa.net/node-and-npm-without-sudo/
wget https://nodejs.org/dist/v14.15.4/node-v14.15.4-linux-x64.tar.xz
mkdir -p $HOME/tools
# extract node to a custom directory, the directory should exist.
tar xvf node-v14.15.4-linux-x64.tar.xz --directory=$HOME/tools
