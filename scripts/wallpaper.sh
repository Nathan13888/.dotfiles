#!/usr/bin/env bash

# load $WALLPAPER_IMAGE environment variable
source $HOME/scripts/load_envs

function load_wp(){
    swww img -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60 $BACKGROUND_IMAGE
}

#perform cleanup and exit
if ! swww query; then
    swww init
fi

load_wp
