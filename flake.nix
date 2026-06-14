{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs =
    inputs@{
      nixpkgs,
      disko,
      lanzaboote,
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
            lanzaboote.nixosModules.lanzaboote
            disko.nixosModules.disko
            ./modules/base.nix
            ./hosts/${name}
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
