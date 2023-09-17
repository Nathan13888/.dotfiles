{
  description = "";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixos Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # NUR
    #nurpkgs = {
    #  url = github:nix-community/NUR;
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    hyprland.url = "github:hyprwm/Hyprland";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nixos-hardware, hyprland, ... }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = {
        # TODO: default home-manager config 
        "attackercow" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {  inherit system nixpkgs home-manager; };
          modules = [
            hyprland.homeManagerModules.default
            ./home-manager/home.nix
          ];
        };
      };

      nixosConfigurations = {
        jirachi = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (nixpkgs) lib;
            inherit inputs; # important for hyprland!
	    inherit system;
          };
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-z
            hyprland.nixosModules.default
            {programs.hyprland.enable = true;}
            ./nixos/configuration.nix
            ./hosts/jirachi/hardware-configuration.nix
          ];
        };
        lennar = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (nixpkgs) lib;
            inherit inputs system;
          };
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
            hyprland.nixosModules.default
            {programs.hyprland.enable = true;}
            ./nixos/configuration.nix
            ./hosts/lennar/hardware-configuration.nix
          ];
        };
      };
    } // inputs.flake-utils.lib.eachDefaultSystem
      (system:
        # nix develop
        let
          pkgs = import inputs.nixpkgs {inherit system; };
        in {
          devShell = pkgs.mkShell {
            name = "installation-shell";
            buildInputs = with pkgs; [ home-manager git];
            #buildInputs = with pkgs; [ wget s-tar home-manager git vim tmux ];
            NIX_CONFIG = "experimental-features = nix-command flakes";
          };
        }
      );

}

