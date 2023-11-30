{ config, pkgs, ... }:

{
  # LibVirt
  virtualisation.libvirtd.enable = true;

  # Podman
  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      #dockerCompat = true;
    };
  };
}
