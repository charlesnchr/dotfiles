# Requirements (see extra)
# - zsh
# - tmux
# - nvim
# - node
# - python

# git clone git@github.com:charlesnchr/dotfiles

source ~/anaconda3/etc/profile.d/conda.sh
conda activate base

# autojump
git clone git://github.com/wting/autojump.git ~/autojump
cd ~/autojump
./install.py

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# antigen download
mkdir -p $HOME/tools
git clone https://github.com/zsh-users/antigen.git $HOME/tools/antigen
zsh -ic "source ~/dotfiles/home_folder/.zshrc && source ~/tools/antigen/bin/antigen.zsh && antigen update"




git config --global user.name "Charles Christensen"
git config --global user.email "charles.n.chr@gmail.com"
sudo gpasswd -a $USER input

