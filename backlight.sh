#!/usr/bin/env bash

STEPS="10"
MAX="$(cat /sys/class/backlight/intel_backlight/max_brightness)"
DEVICE="/sys/class/backlight/intel_backlight/"

function inc {
    TMP=$(( $(cur) + $(stepSize) ))
    echo $TMP > $DEVICE/brightness
}

function dec {
    TMP=$(( $(cur) - $(stepSize) ))
    echo $TMP > $DEVICE/brightness
}

function cur {
    cat $DEVICE/brightness
}

function stepSize {
    echo $(( $MAX / $STEPS ))
}


case "$1" in
    inc)
        inc
        ;;
    dec)
        dec
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
    max)
        echo $MAX
        ;;
    *)
        echo "Missing parameters :("
        exit 1
        ;;
esac
