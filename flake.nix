{
  description = "";
  inputs = {
    # Nixpkgs
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixos Hardware
    #nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # NUR
    nurpkgs = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs @ { self, nixpkgs, nurpkgs, home-manager, hyprland, ... }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = {
        "attackercow" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {  inherit system nixpkgs nurpkgs home-manager; };
          modules = [
            hyprland.homeManagerModules.default
            ./home-manager/home.nix
          ];
        };
      };

      nixosConfigurations = {
        lennar = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (nixpkgs) lib;
            inherit inputs system;
          };
          modules = [
            hyprland.nixosModules.default
            {programs.hyprland.enable = true;}
            ./nixos/configuration.nix
            ./hosts/lennar/hardware-configuration.nix
          ];
        };
      };

      devShell.${system} = (
        import ./nixos/installation.nix {
          inherit system nixpkgs;
        }
      );
    };

}

