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
        # nix run github:nix-community/nixos-anywhere -- --flake .#nixrunner_01 --generate-hardware-config nixos-generate-config ./hosts/nixrunner_01/hardware-configuration.nix <hostname>
        nixbuilder = mkHost {
          name = "nixbuilder";
        };
        nixrunner_01 = mkHost {
          name = "nixrunner_01";
        };
      };
    };
}
