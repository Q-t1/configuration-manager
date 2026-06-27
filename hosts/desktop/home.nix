{ pkgs, ... }:
{
  imports = [
    ../../modules/home/hyprland.nix
    ../../modules/home/dms.nix
    ../../modules/home/firefox.nix
  ];

  home = {
    username = "qt1";
    homeDirectory = "/home/qt1";
    stateVersion = "26.05";
    packages = [ pkgs.deezer-desktop ];
  };
}
