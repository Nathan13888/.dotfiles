#!/usr/bin/env bash

STEPS="10"
MAX="$(cat /sys/class/backlight/intel_backlight/max_brightness)"
DEVICE="/sys/class/backlight/intel_backlight/"

function set {
    echo ${@: -1} > $DEVICE/brightness
}

function inc {
    TMP=$(( $(cur) + $(stepSize) ))
    set $TMP
}

function dec {
    TMP=$(( $(cur) - $(stepSize) ))
    set $TMP
}

function min {
    set 0
}

function max {
    set $MAX
}

function cur {
    cat $DEVICE/brightness
}

function stepSize {
    echo $(( $MAX / $STEPS ))
}


case "$1" in
    set)
        set $@
        ;;
    inc)
        inc
        ;;
    dec)
        dec
        ;;
    min)
        min
        ;;
    max)
        max
        ;;
    cur)
        cur
        ;;
    stepSize)
        stepSize
        ;;
    steps)
        echo $STEPS
        ;;
    max-value)
        echo $MAX
        ;;
    *)
        echo "Missing parameters :("
        exit 1
        ;;
esac
