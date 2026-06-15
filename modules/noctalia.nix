{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    noctalia.packages.${nixpkgs.system}.default
  ];
}
