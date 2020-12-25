#!/usr/bin/env bash

INC="1"
MAX="120"

function getCurVol {
    echo $(pamixer --get-volume)
}

function up {
    if [ $(($(getCurVol)+$INC)) -le $MAX ]
    then
        echo "Increasing Volume by $INC"
        pactl set-sink-volume @DEFAULT_SINK@ +$INC%
        pactl set-sink-mute @DEFAULT_SINK@ 0
    else
        echo "Maximum volume reached."
        pactl set-sink-volume @DEFAULT_SINK@ $MAX%
    fi
}

function dn {
    if [ $(($(getCurVol)-$INC)) -ge 0 ]
    then
        echo "Decreasing Volume by $INC"
        pactl set-sink-volume @DEFAULT_SINK@ -$INC%
        pactl set-sink-mute @DEFAULT_SINK@ 0
    else
        echo "Minimum volume reached."
        pactl set-sink-volume @DEFAULT_SINK@ 0%
    fi
}

function togm {
    echo "Toggling Mute"
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

function mute {
    echo "Muting"
    pactl set-sink-mute @DEFAULT_SINK@ 1
}

case "$1" in
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
