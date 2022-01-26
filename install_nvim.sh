#!/bin/zsh
# vim plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
pip install -U pynvim
nvim +'PlugInstall --sync' +qa
nvim +'LspInstall vimls pylsp jsonls rust_analyzer'
