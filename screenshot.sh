#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

style="$($HOME/.config/rofi/applets/menu/style.sh)"

dir="$HOME/.config/rofi/applets/menu/configs/$style"
rofi_command="rofi -theme $dir/screenshot.rasi"

# Error msg
msg() {
	rofi -theme "$HOME/.config/rofi/applets/styles/message.rasi" -e "Please install 'maim' first."
}

# Options
screen=""
area=""
window=""

# Variable passed to rofi
options="$screen\n$area\n$window"

chosen="$(echo -e "$options" | $rofi_command -p 'App : maim' -dmenu -selected-row 1)"
case $chosen in
    $screen)
		if [[ -f /usr/bin/maim ]]; then
			maim -u | xclip -selection clipboard -t image/png
		else
			msg
		fi
        ;;
    $area)
		if [[ -f /usr/bin/maim ]]; then
			maim -s | xclip -selection clipboard -t image/png
		else
			msg
		fi
        ;;
    $window)
		if [[ -f /usr/bin/maim ]]; then
			maim  -i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png
		else
			msg
		fi
        ;;
esac

