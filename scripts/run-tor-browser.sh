#!/bin/sh
# https://nixos.wiki/wiki/Tor_Browser_in_a_Container

socat -d TCP-LISTEN:6000,fork,bind=192.168.7.10 UNIX-CONNECT:/tmp/.X11-unix/X0 &
xhost +
ssh -X browser@192.168.7.11 run-tor-browser.sh
