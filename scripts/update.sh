#!/usr/bin/env bash

sudo nix-channel --update
nix flake update

# TODO: put everything in tmux
# TODO: custom flake path
flatpak update
home-manager switch --flake .
TMPDIR=/var/tmp sudo nixos-rebuild switch --flake . $@

