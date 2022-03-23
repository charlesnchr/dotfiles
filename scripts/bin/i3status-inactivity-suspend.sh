#!/bin/bash
: ' ----------------------------------------
* Creation Time : Wed 23 Mar 2022 10:55:35 GMT
* Last Modified : Wed 23 Mar 2022 16:31:54 GMT
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

CMD=$1
CURSETTING=$(xfconf-query -c xfce4-power-manager -p "/xfce4-power-manager/inactivity-on-ac")

if [ "$CMD" = "set" ]; then
    if [ "$CURSETTING" = 14 ]; then
        xfconf-query -c xfce4-power-manager -p "/xfce4-power-manager/inactivity-on-ac" -t int -s 1
    else
        xfconf-query -c xfce4-power-manager -p "/xfce4-power-manager/inactivity-on-ac" -t int -s 14
    fi
else # get
    if [ "$CURSETTING" = 14 ]; then
        echo ""
    else
        echo ""
    fi
fi
