{ config, pkgs, lib, ... }:

# let
#   pkgs = import nixpkgs {
#     inherit system;
#     config.allowUnfree = true;
#     config.xdg.configHome = configHome;
#     overlays = [ nurpkgs.overlay ];
#   };

#   nur = import nurpkgs {
#     inherit pkgs;
#     nurpkgs = pkgs;
#   };
# in
{
  imports = [
    ./packages.nix
    ./wm.nix
  ];
  
  home.username = "attackercow";
  home.homeDirectory = "/home/attackercow";

  # You can update Home Manager without changing this value
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

}

