colo() {
    if [ $(cat ~/dotfiles/is_dark_mode) -eq 1 ]; then x=0; else x=1; fi; echo $x > ~/dotfiles/is_dark_mode
}
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
