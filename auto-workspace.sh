#!/usr/bin/env bash

big_mon=DP-1
smol_mon=eDP-1

echo "moving current window to workspace 10"
hyprctl dispatch movetoworkspace 10

echo "moving workspace 10 first"
hyprctl dispatch moveworkspacetomonitor 10 ${smol_mon}


for i in {1..9}; do
  echo "moving workspace $i"
  hyprctl dispatch moveworkspacetomonitor $i ${big_mon}
done

