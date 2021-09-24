#!/usr/bin/env bash

function startPipewire {
    pipewire &
    disown
    pipewire-pulse &
    disown
    pipewire-media-session &
    disown
}

case "$1" in
    restart)
        pkill pipewire
        startPipewire
        ;;
    *)
        startPipewire
        ;;
esac
