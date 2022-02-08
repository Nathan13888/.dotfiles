#!/usr/bin/env bash

INC="1"
MAX="120"

notify () {
    dunstify "Volume" "$@" -u low
}

function isMicMuted {
    MIC=@DEFAULT_SOURCE@
    echo $(pamixer --get-mute --source $MIC)
}

function isMMicon {
    if [ $(isMicMuted) == true ]
    then
        echo ""
    else
        echo ""
    fi
}

function getCurVol {
    echo $(pamixer --get-volume)
}

function up {
    if [ $(($(getCurVol)+$INC)) -le $MAX ]
    then
        echo "Increasing Volume by $INC"
        unmute
        pamixer --allow-boost -i $INC
    else
        notify "Maximum volume reached."
        pamixer --set-volume $MAX
    fi
}

function dn {
    if [ $(($(getCurVol)-$INC)) -ge 0 ]
    then
        echo "Decreasing Volume by $INC"
        unmute
        pamixer --allow-boost -d $INC
    else
        notify "Minimum volume reached."
        pamixer --set-volume 0
    fi
}

function togmic {
    notify "Toggling default source"
    pamixer --default-source -t
}

function togm {
    SINKS=($(pamixer --list-sinks | grep '"' | cut -d ' ' -f 1))
    for SINK in ${SINKS[@]}; do
      #notify "Toggling default sink"
      echo "Toggling mute of $SINK"
      pamixer -t --sink $SINK
    done;
}

function mute {
    notify "Muting default sink"
    pamixer -m
}

function unmute {
    notify "Unmuting default sink"
    pamixer -u
}

case "$1" in
    isMMicon)
        isMMicon
        ;;
    isMicMuted)
        isMicMuted
        ;;
    togmic)
        togmic
        ;;
    curv)
        echo $(getCurVol)
        ;;
    up)
        up
        ;;
    dn)
        dn
        ;;
    togm)
        togm
        ;;
    mute)
        mute
        ;;
    *)
        echo "Missing parameters :("
        exit 1
        ;;
esac
