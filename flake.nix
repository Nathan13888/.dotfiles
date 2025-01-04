{
  description = "";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-staging-next.url = "github:NixOS/nixpkgs/staging-next";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixos Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix LD
    #nix-ld.url = "github:Mic92/nix-ld";
    #nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    # Chaotic
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # NUR
    #nurpkgs = {
    #  url = "github:nix-community/NUR";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    hyprland.url = "github:hyprwm/Hyprland";
    flake-utils.url = "github:numtide/flake-utils";

    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nix-darwin, nixpkgs, nixpkgs-staging-next, home-manager, nixos-hardware, chaotic, hyprland, ... }:
    let
      system = "x86_64-linux";
      darwin_config = {
        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;
      };
    in
    {
      darwinConfigurations = {
        darkrai = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            darwin_config
            ./hosts/darkrai/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        # TODO: default home-manager config 
        "Nathan" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {  inherit system nixpkgs home-manager; };
          modules = [
            #hyprland.homeManagerModules.default
            ./home-manager/home.nix
          ];
        };
      };

      nixosConfigurations = {
        jirachi = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (nixpkgs) lib;
            inherit nixpkgs-staging-next;
            inherit inputs; # important for hyprland!
            inherit system;
          };
          modules = [
            chaotic.nixosModules.default
            #nix-ld.nixosModules.nix-ld
            #hyprland.nixosModules.default
            #{programs.hyprland.enable = true;}
            # TODO: ./secrets/eduroam.nix

            nixos-hardware.nixosModules.lenovo-thinkpad-z
            ./hosts/jirachi/hardware-configuration.nix
            ./nixos/configuration.nix

	    #<home-manager/nixos>
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
            #{programs.hyprland.enable = true;}
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

