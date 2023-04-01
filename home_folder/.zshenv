colo() {
    if [ $(cat ~/dotfiles/is_dark_mode) -eq 1 ]; then x=0; else x=1; fi; echo $x > ~/dotfiles/is_dark_mode
}

. "$HOME/.cargo/env"

source $HOME/dotfiles/.zshrc_local
