{ config, pkgs, lib, ... }:

{
  imports = [
    ./packages.nix
    ./wm.nix
  ];

  home.username = "Nathan";
  home.homeDirectory = "/home/attackercow";

  # You can update Home Manager without changing this value
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

}

