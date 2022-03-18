#!/bin/bash
: ' ----------------------------------------
* Creation Time : Fri 18 Mar 2022 11:31:12 GMT
* Last Modified : Fri 18 Mar 2022 11:32:02 GMT
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
* Info : From gist https://gist.github.com/davejamesmiller/1965569?permalink_comment_id=1284731
----------------------------------------'

ask() {
    local prompt default reply

    if [[ ${2:-} = 'Y' ]]; then
        prompt='Y/n'
        default='Y'
    elif [[ ${2:-} = 'N' ]]; then
        prompt='y/N'
        default='N'
    else
        prompt='y/n'
        default=''
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read -r reply </dev/tty

        # Default?
        if [[ -z $reply ]]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}
