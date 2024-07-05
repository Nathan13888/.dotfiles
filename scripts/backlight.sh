#!/usr/bin/env bash

STEPS="12"
MAX="100"
MIN="1"
DEFAULT="50"
STATE_FILE="/tmp/screen_brightness_file"

function set {
    echo "Setting brightness to ${@: -1}"
    xbacklight -set ${@: -1}
    cur > $STATE_FILE
}

function inc {
    #TMP=$(( $(cur) + $(stepSize) ))
    #TMP=$(( $TMP<=$MAX ? $TMP : $MAX ))
    #set $TMP
    if [ ! -f $STATE_FILE ]; then
        xbacklight -set $(cur)
    fi
    xbacklight -inc $(stepSize)
    cur > $STATE_FILE
}

function dec {
    #TMP=$(( $(cur) - $(stepSize) ))
    #TMP=$(( $TMP>=0 ? $TMP : $MIN ))
    #set $TMP
    if [ ! -f $STATE_FILE ]; then
        xbacklight -set $(cur)
    fi
    xbacklight -dec $(stepSize)
    cur > $STATE_FILE
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
    disable)
        # change brightness without changing state file
	xbacklight -set 0
	;;
    restore)
	restore="$(cat $STATE_FILE)"
	# TODO: don't attempt restore if brightness is non-zero?
	if [ -z "$restore" ]; then
	    set "$DEFAULT"
	else
	    set $restore
	fi
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
