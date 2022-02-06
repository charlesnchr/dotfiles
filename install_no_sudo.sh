#!/bin/bash

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


