# Requirements (see extra)
# - zsh
# - tmux
# - nvim
# - node
# - python

# autojump
git clone git://github.com/wting/autojump.git ~/autojump
cd ~/autojump
./install.py

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# antigen download
mkdir -p $HOME/tools
git clone https://github.com/zsh-users/antigen.git $HOME/tools/antigen
source ~/tools/antigen/antigen.zsh
antigen update


# symbolic links
ln -sfn ~/dotfiles/.zshrc ~/.zshrc
ln -sfn ~/dotfiles/nvim ~/.config/nvim
ln -sfn ~/dotfiles/.vimrc ~/.vimrc
ln -sfn ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sfn ~/dotfiles/.spacemacs ~/.spacemacs

# Nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
pip install -U pynvim
nvim -c PlugInstall
