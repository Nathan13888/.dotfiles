#!/bin/sh
MONITOR=DP1-1
#MONITOR=DP1-3
#TODO:
#MONITOR=HDMI1

xrandr --output $MONITOR --mode 3840x2160 --scale 1x1 --output XWAYLAND1 --same-as XWAYLAND0 --mode 1920x1080 --scale 2x2

#MONITOR2=HDMI1


xrandr --output $MONITOR --mode 3840x2160 --scale 1x1 --output eDP1 --same-as $MONITOR --mode 1920x1080 --scale 2x2
#xrandr --output $MONITOR --mode 3840x2160 --scale 1x1 --output eDP1 --same-as DP1-2 --mode 1920x1080 --scale 2x2
#xrandr --output $MONITOR --mode 3840x2160 --scale 1x1 --output eDP1 --same-as DP1-2 --mode 1920x1080 --scale 2x2
