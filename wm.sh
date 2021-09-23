#!/bin/bash

# TODO
# - function keys
# - services
# - restart
# - make RUST version?

# MAYBE:
# - json config??
# - required packages
# - get fonts

f1="firefox-nightly"
f2="discord element-desktop-nightly"
f3="teams"
f4="~/.local/bin/obs-virt.sh" # TODO: make script run within terminal
f5="$FILEMANAGER"
screenshot="flameshot gui"

###

VERBOSE=0

function open {
    set -m
    echo "Executing: '$@'"
    for p in "$@"; do
        if [ $VERBOSE -gt 0 ]; then
            echo -e "Executing '$p'\n"
        fi
        if [ -x $p ]; then
            echo -e "CANNOT EXECUTE '$p'"
        else
            nohup $p &
            disown
        fi
    done
}

function setSettings {
    xset r rate 210 40
    xset m 3/2
}

function startup {
    #open picom
# - screenshots
    open dunst
    #~/.config/polybar/launch.sh
    nohup feh --bg-scale --randomize ~/Desktop/Wallpapers/ &
    disown

    open xbanish
    open numlockx
    open flameshot
    open nm-applet
    open fcitx5
    xss-lock --transfer-sleep-lock -- ~/.local/bin/lock.sh --nofork

    setSettings
}

###

#echo ${@: -1}
#if [ -v ${@: -1} ] && [[ "${@: -1}" -eq "-v" ]]; then
#    VERBOSE=1
#    echo "Verbose: $VERBOSE"
#fi

case "$1" in
    init)
        startup
        setSettings
        ;;
    restart)
        source ~/.config/polybar/launch.sh &
        setSettings
        ;;
    open)
        if [ -v $2 ] && [ -v $3 ]; then
            open $3
        fi
        ;;
    f*)
        if [ -v ${!1} ]; then
            echo "'$1' was not found"
        else
            echo ${!1}
            open ${!1}
        fi
        ;;
    screenshot)
        nohup $screenshot
        ;;
    *)
        echo "Unknown or missing parameters"
        exit 1
        ;;
esac

