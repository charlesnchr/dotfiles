#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install tmux
brew install zsh
brew install neovim
brew install universal-ctags
brew install docker
brew install --cask firefox
brew install --cask spotify
brew install --cask fiji
brew install --cask skim
brew install --cask iterm2
brew install --cask openinterminal
brew install --cask notion
brew install --cask raycast
brew install --cask visual-studio-code
brew install --cask google-chrome
brew install --cask alt-tab
brew install --cask whatsapp

brew install keepassxc
brew install cmake python mono go nodejs
brew install font-hack-nerd-font
brew install font-caskaydia-cove-nerd-font
brew install --cask betterzip
brew install --cask handbrake
brew install --cask mactex
brew install neofetch
brew install ctags

brew tap jakehilborn/jakehilborn && brew install displayplacer
brew tap railwaycat/emacsmacport && brew install emacs-mac --with-no-title-bars
brew install macvim

brew install esolitos/ipa/sshpass

# conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -O ~/anaconda.sh
bash ~/anaconda.sh -b -p $HOME/anaconda3

__conda_setup="$('~/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
eval "$__conda_setup"
conda install -c conda-forge rclone

chsh -s /usr/local/bin/zsh
