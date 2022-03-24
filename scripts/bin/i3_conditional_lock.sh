#!/bin/bash
: ' ----------------------------------------
* Creation Time : Wed 23 Mar 2022 22:23:25 GMT
* Last Modified : Wed 23 Mar 2022 22:25:15 GMT
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

if [ $(xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode) = false ]; then
    # below is based on blurlock, /usr/bin/blurlock on manjaro i3
    set -eu

    RESOLUTION=$(xrandr -q|sed -n 's/.*current[ ]\([0-9]*\) x \([0-9]*\),.*/\1x\2/p')

    # lock the screen
    import -silent -window root jpeg:- | convert - -scale 20% -blur 0x2.5 -resize 500% RGB:- | \
        i3lock --raw $RESOLUTION:rgb -i /dev/stdin -e $@

    # sleep 1 adds a small delay to prevent possible race conditions with suspend
    sleep 1

    exit 0
fi


