#!/usr/bin/env bash

## Files and cmd
EWW="eww -c $HOME/.config/eww/"
focusmon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .id')

## Run eww daemon if not running already
if [[ ! $(pidof eww) ]]; then
    ${EWW} daemon
    sleep 1
fi

# Open widgets
## Open sidebar
hyprctl dispatch focusmonitor "$focusmon"
# primary display id
source $HOME/scripts/load_envs;

# Open widgets for primary display
# use this for notifications : ${EWW} open-many "sidebar$PRIMARY_MONITOR_ID" "notifications$PRIMARY_MONITOR_ID"
# TODO: fix sidebar??
#${EWW} open "sidebar$PRIMARY_MONITOR_ID"

## Open standard widgets and bar
NB_MONITORS=($(hyprctl monitors -j | jq -r '.[] | .id'))
for id in "${NB_MONITORS[@]}"; do
    # make top bar for every display
    bar="bar$id"
    hyprctl dispatch focusmonitor "$id"
    ${EWW} open "$bar"
done
