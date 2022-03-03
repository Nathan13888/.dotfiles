#!/usr/bin/env bash

# Terminate already running bar instances
pkill polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config

for m in $(polybar --list-monitors | cut -d":" -f1); do
    #MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g')

    bar="bar-i3"
    if [ -n "$1" ]; then
        bar=$1
    fi

    echo "Launching $bar"

    TMP="$(mktemp -u)_polybar"
    FC_DEBUG=1 WIRELESS=$(ls /sys/class/net/ | grep ^wl | awk 'NR==1{print $1}') MONITOR=$m polybar --reload $bar > $TMP 2>&1 & disown
done

echo "Polybar launched..."
