#!/bin/bash
: ' ----------------------------------------
* Creation Time : Wed 23 Mar 2022 11:13:35 GMT
* Last Modified : Wed 23 Mar 2022 11:37:42 GMT
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

CMD=$1
CURSETTING=$(xfconf-query -c xfce4-power-manager -p "/xfce4-power-manager/presentation-mode")

if [ "$CMD" = "set" ]; then
    if [ "$CURSETTING" = "true" ]; then
        xfconf-query -c xfce4-power-manager -p "/xfce4-power-manager/presentation-mode" -s "false"
    else
        xfconf-query -c xfce4-power-manager -p "/xfce4-power-manager/presentation-mode" -s "true"
    fi
else # get
    if [ "$CURSETTING" = "true" ]; then
        echo ""
    else
        echo ""
    fi
fi
