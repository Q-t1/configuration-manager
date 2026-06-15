{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs =
    inputs@{
      nixpkgs,
      disko,
      lanzaboote,
      home-manager,
      niri,
      noctalia,
      nixos-facter-modules,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";

      mkHost =
        {
          name,
          extraModules ? [ ],
          specialArgs ? { },
        }:
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; } // specialArgs;
          modules = [
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            niri.nixosModules.niri
            ./modules/base.nix
            #./modules/noctalia.nix
            ./hosts/${name}
            # Module Home Manager (NixOS)
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.qt1.home.stateVersion = "26.05";
            }
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost {
          name = "desktop";
        };
      };
    };
}
