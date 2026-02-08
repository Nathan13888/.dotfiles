#!/usr/bin/env bash

nix-shell -p nix -I nixpkgs=channel:nixpkgs-unstable --run "nix --version"

# sudo nix-env --install --file '<nixpkgs>' --attr nix cacert -I nixpkgs=channel:nixpkgs-unstable
# sudo systemctl daemon-reload
# sudo systemctl restart nix-daemon

sudo nix-channel --update
nix flake update

# TODO: put everything in tmux
# TODO: custom flake path
# TODO: check for CTRL-C interupt
flatpak update
home-manager switch --flake .
TMPDIR=/var/tmp sudo nixos-rebuild switch --flake . $@
