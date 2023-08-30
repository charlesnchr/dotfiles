FROM ubuntu:20.04

USER root
SHELL ["/bin/bash", "-c"]


RUN \
	apt-get -qq -y update \
	&& apt-get -qq -y install wget curl zsh fuse git xz-utils sudo openssh-client


# Create user "docker" with sudo powers
RUN useradd -m docker && \
    usermod -aG sudo docker && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cp /root/.bashrc /home/docker/ && \
    mkdir /home/docker/data && \
    chown -R --from=root docker /home/docker

USER docker
WORKDIR /home/docker
ENV HOME /home/docker

RUN \
	mkdir -p $HOME/tools \
	&& mkdir -p $HOME/bin \
	&& mkdir -p $HOME/.config

RUN \
	echo 'anaconda' \
	&& wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh \
	&& bash ~/anaconda.sh -b -p $HOME/anaconda3 \
	&& rm anaconda.sh \
	&& source ~/anaconda3/etc/profile.d/conda.sh \
	&& conda activate base \
	&& conda install -y -c conda-forge universal-ctags rclone tmux \
	&& pip install ranger-fm scikit-image numpy matplotlib

RUN \
	echo 'nodejs' \
	&& wget https://nodejs.org/dist/v14.15.4/node-v14.15.4-linux-x64.tar.xz \
	&& tar xvf node-v14.15.4-linux-x64.tar.xz --directory=$HOME/tools \
	&& rm node-v14.15.4-linux-x64.tar.xz \
	&& ln -sf $HOME/tools/node-v14.15.4-linux-x64/bin/npm $HOME/bin/npm \
	&& ln -sf $HOME/tools/node-v14.15.4-linux-x64/bin/npx $HOME/bin/npx \
	&& ln -sf $HOME/tools/node-v14.15.4-linux-x64/bin/node $HOME/bin/node

RUN \
	echo 'neovim' \
	&& curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
	&& chmod u+x nvim.appimage \
	&& mkdir -p $HOME/bin \
	&& mv ./nvim.appimage $HOME/bin/nvim

RUN \
	echo 'dotfiles' \
	&& git clone https://github.com/charlesnchr/dotfiles \
	&& ln -sfn ~/dotfiles/.zshrc ~/.zshrc \
	&& ln -sfn ~/dotfiles/.vimrc ~/.vimrc \
	&& ln -sfn ~/dotfiles/.tmux.conf ~/.tmux.conf \
	&& ln -sfn ~/dotfiles/.spacemacs ~/.spacemacs


SHELL ["/bin/zsh", "-c"]

RUN \
	echo 'symbolic links' \
	&& source ~/anaconda3/etc/profile.d/conda.sh \
	&& conda activate base \
	&& echo 'fzf' \
	&& git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
	&& ~/.fzf/install --all \
	&& echo 'tmux plugin manager' \
	&& git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
	&& ~/.tmux/plugins/tpm/bin/install_plugins \
	&& echo 'antigen download' \
	&& git clone https://github.com/zsh-users/antigen.git $HOME/tools/antigen \
	&& source ~/tools/antigen/bin/antigen.zsh \
	&& antigen update

RUN \
	echo 'vimplug' \
	&& source $HOME/.zshrc \
	&& sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \
	&& pip install -U pynvim \
	&& ln -sfn ~/dotfiles/nvim ~/.config/nvim

CMD [ "/bin/zsh" ]

# Use C.UTF-8 locale to avoid issues with ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
