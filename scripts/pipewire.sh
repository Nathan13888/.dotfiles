#!/usr/bin/env bash

function startPipewire {
    TMP="$(mktemp -u)_pipewire"
    /usr/bin/pipewire | tee $TMP &
    disown
    #TMP="$(mktemp -u)_pipewire_pulse"
    #/usr/bin/pipewire-pulse | tee $TMP &
    #disown
    #/usr/bin/pipewire-media-session &
    #sleep 2
    #TMP="$(mktemp -u)_wireplumber"
    #/usr/bin/wireplumber | tee $TMP &
    #disown
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
