#!/usr/bin/env bash

if grep closed /proc/acpi/button/lid/*/state; then
  echo "lock.sh: lid is closed"
  $HOME/scripts/backlight.sh disable

  # lock screen
  set -euo pipefail
  (
    until fprintd-verify; do
      echo "Failed to verify fingerprint at $(date)" | systemd-cat
    done

    echo "Unlocked at $(date)" | systemd-cat
    pkill -USR1 hyprlock
  ) &
  hyprlock
  kill $(jobs -p)
  pkill fprintd-verify

  #if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
  # TODO: auto detect monitor at ID 0

  # TODO: fix
  #hyprctl keyword monitor "eDP-1, disable"
  #fi
else
  echo "lock.sh: lid is open or unknown state"
  # TODO: do same thing

  # TODO: fix
  $HOME/scripts/backlight.sh restore
  #hyprctl keyword monitor "eDP-1, 2560x1440@165, 0x0, 1"
fi
