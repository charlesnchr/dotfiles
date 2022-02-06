#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
bash ~/anaconda.sh -b -p $HOME/anaconda3
source ~/anaconda3/etc/profile.d/conda.sh
conda activate base

conda install -y -c conda-forge zsh universal-ctags rclone tmux
pip install ranger scikit-image numpy matplotlib opencv-python

