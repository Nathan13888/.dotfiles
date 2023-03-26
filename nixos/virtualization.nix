{ config, pkgs, ... }:

{
  # LibVirt
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Podman
  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      #dockerCompat = true;
    };
  };
  
}