#!/bin/bash
: ' ----------------------------------------
* Creation Time : Mon 11 Apr 2022 22:00:29 BST
* Last Modified : Wed 24 Aug 2022 14:39:17 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# function also returns full process info
function ppgrep() { pgrep "$@" | xargs --no-run-if-empty ps fp; }

# run only once, but different to lua function
pgrep cloud-drive-ui || synology-drive &
pgrep geoclue || /usr/lib/geoclue-2.0/demos/agent &
pgrep redshift-gtk || redshift-gtk &

# not sure what this does (from i3)
# ff-theme-util
# fix_xcursor


nitrogen --restore
source ~/.xprofile
libinput-gestures-setup restart
# ppgrep python | grep usbwatchdog.py || ~/anaconda3/bin/python ~/bin/usbwatchdog.py &

# find pwa app
# exo-open $(rg -i spotify /home/cc/.local/share/applications | awk '{split($0,a,":"); print a[1]}')
# pgrep Spotify || exo-open ~/.local/share/applications/webcatalog-spotify.desktop
# pgrep ncspot || kitty -e ~/bin/ncspot

# if [ "$(hostname)" == "cc" ]; then
notify-send "Starting Kmonad"
kmonad ~/.config/lenovo-thinkpad.kbd
# fi

