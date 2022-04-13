#!/bin/bash
: ' ----------------------------------------
* Creation Time : Mon 11 Apr 2022 22:00:29 BST
* Last Modified : Tue 12 Apr 2022 22:31:28 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# function also returns full process info
function ppgrep() { pgrep "$@" | xargs --no-run-if-empty ps fp; }

# run only once, but different to lua function
pgrep cloud-drive-ui || synology-drive &
pgrep geoclue || /usr/lib/geoclue-2.0/demos/agent &
pgrep redshift || redshift-gtk &

# not sure what this does (from i3)
ff-theme-util
fix_xcursor


nitrogen --restore
~/.xprofile
libinput-gestures-setup restart
ppgrep python | grep usbwatchdog.py || ~/anaconda3/bin/python ~/bin/usbwatchdog.py &

