#!/usr/bin/env bash

STEP="5"
MAX="100"

notify() {
  dunstify "Volume" "$@" -u low
}

function isMuted {
  pamixer --get-mute
}

function isMicMuted {
  MIC=@DEFAULT_SOURCE@
  pamixer --get-mute --source $MIC
}

function icon {
  vol="$(pamixer --get-volume)"
  current="${vol%%%}"

  if [[ "$(pamixer --get-mute)" == "false" ]]; then
    if [[ "$current" -eq "0" ]]; then
      echo "🔈"
    elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
      echo "🔉"
    elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
      echo "🔊"
    elif [[ ("$current" -ge "60") && ("$current" -le "$MAX") ]]; then
      echo "🔊+"
    fi
  else
    echo "🔇"
  fi
}

function isMMicon {
  if [ $(isMicMuted) == true ]; then
    echo ""
  else
    echo ""
  fi
}

function getCurVol {
  pamixer --get-volume
}

# round to multiple of multiple of STEP
function up {
  if [ $(($(getCurVol) + $STEP)) -le $MAX ]; then
    echo "Increasing Volume by $STEP"
    unmute
    pamixer --allow-boost -i $STEP
    notify "Current volume: $(getCurVol)"
  else
    notify "Maximum volume reached."
    pamixer --set-volume $MAX
  fi
}

function dn {
  if [ $(($(getCurVol) - $STEP)) -gt 0 ]; then
    echo "Decreasing Volume by $STEP"
    unmute
    pamixer --allow-boost -d $STEP
    notify "Current volume: $(getCurVol)"
  else
    notify "Minimum volume reached."
    mute
    pamixer --set-volume 0
  fi
}

function togmic {
  notify "Toggling default source"
  pamixer --default-source -t
}

function togm {
  SINKS=($(pamixer --list-sinks | grep '"' | cut -d ' ' -f 1))
  for SINK in ${SINKS[@]}; do
    #notify "Toggling default sink"
    echo "Toggling mute of $SINK"
    pamixer -t --sink $SINK
  done
}

function mute {
  notify "Muting default sink"
  pamixer -m
}

function unmute {
  if [[ "$(pamixer --get-mute)" == "true" ]]; then
    notify "Unmuting default sink"
    pamixer -u
  else
    echo "Already unmuted."
  fi
}

case "$1" in
  icon)
    icon
    ;;
  isMMicon)
    isMMicon
    ;;
  isMuted)
    isMuted
    ;;
  isMicMuted)
    isMicMuted
    ;;
  togmic)
    togmic
    ;;
  cur)
    echo $(getCurVol)
    ;;
  set)
    pamixer --set-volume ${@: -1}
    ;;
  set-mic)
    pamixer --default-sink --set-volume ${@: -1}
    ;;
  up)
    up
    ;;
  dn)
    dn
    ;;
  togm)
    togm
    ;;
  mute)
    mute
    ;;
  *)
    echo "Missing parameters :("
    exit 1
    ;;
esac
