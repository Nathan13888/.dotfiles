#!/usr/bin/env bash

# create tmp file for logging
# TODO: TMPFILE=$(mktemp /tmp/wallpaper.sh/output.XXXXXX.log)
#TMPFILE="$(mktemp)"
echo "\$TMPFILE=$TMPFILE"

#TODO: socket file

# redirect script output to $TMPFILE
#exec > $TMPFILE # TODO:
exec 2>&1

#####################################################################

notify-send "Started Wallpaper Carousel" -u low

source $HOME/scripts/load_envs

# SOURCE: `swww help img`
export SWWW_TRANSITION="simple"
export SWWW_TRANSITION_DURATION="3"
export SWWW_TRANSITION_FPS=120
export SWWW_TRANSITION_STEP=10
export WWW_TRANSITION_BEZIER="0.0,0.0,1.0,1.0"

# SOURCE: https://github.com/Horus645/swww/blob/main/example_scripts/swww_randomize.sh

# displays a wallpaper with swww
function display_wp {
  echo "Displaying image: '$1'"
  swww img "$1"
}

# generates/outputs a randomized list of wallpapers
function get_scrambled_list {
  find "$WALLPAPERS" -type f |
    while read -r img; do
      echo "$(shuf -i 0-999 -n 1):$img"
    done |
    sort -n | cut -d':' -f2-
}

# sarts a wallpaper carousel
function load_wp() {
  # This controls (in seconds) when to switch to the next image
  INTERVAL=30

  echo "Starting wallpaper carousel"
  while true; do
    get_scrambled_list |
      while read -r img; do
        # TODO: detect error displaying image
        display_wp "$img"
        sleep $INTERVAL
      done
  done
}

function c_swww() {
  # start swww daemon if not started
  if ! swww query; then
    echo "Initializing SWWW"
    swww init
  fi
}

# process flag
case "$1" in
# TODO: next wallpaper function (during sleep)
# TODO: check for invalid wallpaper images
switch)
  echo "Changing single wallpaper"
  c_swww
  IMG=$(get_scrambled_list | head -n 1)
  display_wp "$IMG"
  exit 0
  ;;
esac

# kill all other wallpaper.sh scripts
echo "Killing all other wallpaper.sh scripts"
ps -ef | grep scripts/wallpaper.sh | grep bash |
  grep -v "$$" | grep -v "bwrap" | grep -v "grep" |
  awk '{print $2}' | xargs kill -9
echo "Killing SWWW"
swww kill
echo "Destroying SWWW cache"
rm -r $HOME/.cache/swww
c_swww

load_wp
