#!/bin/sh
flatpak override --user --filesystem="~/git/spotify-adblock/target/release/libspotifyadblock.so" --filesystem="~/.config/spotify-adblock/config.toml" com.spotify.Client
flatpak run --command=sh com.spotify.Client -c 'eval "$(sed s#LD_PRELOAD=#LD_PRELOAD=$HOME/.spotify-adblock/spotify-adblock.so:#g /app/bin/spotify)"'
