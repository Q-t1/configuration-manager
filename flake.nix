{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "git+https://github.com/nix-community/lanzaboote?rev=001e560fffc8f0235e9db20ebeb4ccde0ade1caf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprshell = {
      url = "github:H3rmt/hyprshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      disko,
      lanzaboote,
      home-manager,
      dms,
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
          specialArgs = {
            inherit inputs;
          }
          // specialArgs;

          modules = [
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            dms.nixosModules.dank-material-shell
            dms.nixosModules.greeter

            ./modules/base.nix
            ./hosts/${name}

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";

              home-manager.users.qt1 = import ./hosts/${name}/home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ]
          ++ extraModules;
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
