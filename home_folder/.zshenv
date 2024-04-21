colo() {
    if [ $(cat ~/dotfiles/is_dark_mode) -eq 1 ]; then x=0; else x=1; fi; echo $x > ~/dotfiles/is_dark_mode
}
export PATH="$HOME/bin:$PATH"
