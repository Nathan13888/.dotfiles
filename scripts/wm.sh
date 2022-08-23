#!/bin/sh

f5="$FILEMANAGER"
screenshot="flameshot gui"

VERBOSE=0

function open {
    set -m
    echo "Executing: '$@'"
    for p in "$@"; do
        if [ $VERBOSE -gt 0 ]; then
            echo -e "Executing '$p'\n"
        fi
        # TODO: get base command instead
        if [ -x $p ]; then
            echo -e "CANNOT EXECUTE '$p'"
        else
            nohup $p > /dev/null &
            disown
        fi
    done
}

function notify {
    notify-send "Services" "$@"
}

function setSettings {
    notify "Updating XORG settings"
    xset r rate 210 40
    xset m 3/2
    bash $HOME/scripts/xrandr-dup.sh
}

function startup {
    # Gnome Keyring
    eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK

    #open picom
    open dunst
    #~/.config/polybar/launch.sh
    nohup feh --bg-scale --randomize ~/Desktop/Wallpapers/ > /dev/null &
    disown

    open xbanish
    open numlockx
    open flameshot
    open nm-applet
    open fcitx5
    xss-lock --transfer-sleep-lock -- ~/.local/bin/lock.sh --nofork

    setSettings
    # Startup Applications
    #keepassxc
#   notify "Starting Easyeffects..."
#   #easyeffects --gapplication-service &
}

case "$1" in
    init)
        startup
        setSettings
        ;;
    restart)
        source ~/.config/polybar/launch.sh &
        setSettings
        startAudio
        ;;
    open)
        if [ -v $2 ]; then
            echo "No command specified."
            exit 1
        fi
        # TODO: support all args
        echo -e "Opening '$2'\n"
        open $2
        ;;
    fj)
        fj $3
        ;;
    screenshot)
        nohup $screenshot > /dev/null
        ;;
    keepassxc)
        TMP="$(mktemp -u)_keepassxc"
        open keepassxc | tee -a $TMP
        ;;
    f1)
        TMP="$(mktemp -u)_chromium"
        brave >> $TMP 2>&1 &
        ;;
    f2)
        if [ `ps aux|grep discord|wc -l` -eq 1 ]; then
            TMP="$(mktemp -u)_discord"
            open discord | tee -a $TMP
        fi
        if [ `ps aux|grep element-desktop|wc -l` -eq 1 ]; then
            TMP="$(mktemp -u)_element"
            element-desktop | tee -a $TMP &
        fi
        ;;
    f3)
        if [ `pgrep teams|wc -l` -eq 0 ]; then
            fj teams
        fi
        ;;
    f4)
        if [ `pgrep spotify|wc -l` -eq 0 ]; then
            TMP="$(mktemp -u)_spotify"
            firejail spotify-adblock | tee -a $TMP &
            disown
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
    *)
        echo "Unknown or missing parameters"
        exit 1
        ;;
esac

