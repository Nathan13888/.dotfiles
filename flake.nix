{
  description = "";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

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
  };
  
  outputs = inputs @ { self, nixpkgs, nurpkgs, home-manager }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = (
        import ./home-manager/home-conf.nix {
          inherit system nixpkgs nurpkgs home-manager;
        }
      );

      nixosConfigurations = {
        lennar = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (nixpkgs) lib;
	    inherit inputs system;
	  };
          modules = [
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

