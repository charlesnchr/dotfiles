#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
bash ~/anaconda.sh -b -p $HOME/anaconda3
source ~/anaconda3/etc/profile.d/conda.sh
conda activate base

conda install -y -c conda-forge universal-ctags rclone ripgrep
pip install ranger-fm scikit-image numpy matplotlib opencv-python

