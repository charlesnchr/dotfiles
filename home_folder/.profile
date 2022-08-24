export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=nvim
export TERMINAL=alacritty
export TERMINAL_CMD="alacritty -e"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
if [ -n "$DISPLAY" ]; then
    export BROWSER=firefox
else
    export BROWSER=links
fi

export PATH="$HOME/.poetry/bin:$PATH"
