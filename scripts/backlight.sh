#!/usr/bin/env bash

STEPS="10"
MAX="100"
MIN="1"

function set {
    echo "Setting brightness to ${@: -1}"
    xbacklight -set ${@: -1}
}

function inc {
    TMP=$(( $(cur) + $(stepSize) ))
    TMP=$(( $TMP<=$MAX ? $TMP : $MAX ))
    set $TMP
}

function dec {
    TMP=$(( $(cur) - $(stepSize) ))
    TMP=$(( $TMP>=0 ? $TMP : $MIN ))
    set $TMP
}

function min {
    set $MIN
}

function max {
    set $MAX
}

function cur {
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
