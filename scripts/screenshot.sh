#/usr/bin/env bash

# SOURCE: https://github.com/hyprwm/Hyprland/discussions/416

if [ "$(hyprctl activewindow)" = "Invalid" ]; then
  wayshot --stdout | wl-copy
else
  if [[ -z "$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == "$(hyprctl activewindow -j | jq -r '.workspace.id')\)" and select(.size == [2560,1440])")" ]]; then
    hyprctl --batch "keyword decoration:active_opacity 1;keyword decoration:inactive_opacity 1"
    wayshot -s "$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == "$(hyprctl activewindow -j | jq -r '.workspace.id')\)"" | jq -r ".at,.size" | jq -s "add" | jq '_nwise(4)' | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"' | slurp -f '%x %y %w %h')" --stdout | wl-copy
    hyprctl reload
  else
    hyprctl --batch "keyword decoration:active_opacity 1;keyword decoration:inactive_opacity 1"
    wayshot --stdout | wl-copy
  fi
fi
