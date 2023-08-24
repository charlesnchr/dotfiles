#!/bin/bash
: ' ----------------------------------------
* Creation Time : Wed 23 Mar 2022 10:55:35 GMT
* Last Modified : Wed 20 Apr 2022 01:31:13 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

CMD=$1
CURSETTING=$(xfconf-query -c xfce4-power-manager -p "/xfce4-power-manager/inactivity-on-ac")

if [ "$CMD" = "set" ]; then
    if [ "$CURSETTING" = 14 ]; then
        xfconf-query -c xfce4-power-manager -p "/xfce4-power-manager/inactivity-on-ac" -t int -s 20
        notify-send "Automatic suspend: ON"
    else
        xfconf-query -c xfce4-power-manager -p "/xfce4-power-manager/inactivity-on-ac" -t int -s 14
        notify-send "Automatic suspend: OFF"
    fi
else # get
    if [ "$CURSETTING" = 14 ]; then
        echo ""
    else
        echo ""
    fi
fi
