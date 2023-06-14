#!/usr/bin/env bash

STEPS="30"
#MAX="$(cat /sys/class/backlight/intel_backlight/max_brightness)"
MAX="100"
#DEVICE="/sys/class/backlight/intel_backlight/"

function set {
    #echo ${@: -1} > $DEVICE/brightness
    xbacklight -set ${@: -1}
}

function inc {
    TMP=$(( $(cur) + $(stepSize) ))
    TMP=$(( $TMP<=$MAX ? $TMP : $MAX ))
    set $TMP
}

function dec {
    TMP=$(( $(cur) - $(stepSize) ))
    TMP=$(( $TMP>=0 ? $TMP : 0 ))
    set $TMP
}

function min {
    set 0
}

function max {
    set $MAX
}

function cur {
    #cat $DEVICE/brightness
    xbacklight -get
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
    toggle-pg) # Lenovo's privacy guard
        echo TODO
        echo /proc/acpi/ibm/lcdshadow
        ;;
    *)
        echo "Missing parameters :("
        exit 1
        ;;
esac
