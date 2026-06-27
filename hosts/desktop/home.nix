{ pkgs, inputs, ... }:
{
  imports = [
    inputs.hyprshell.homeModules.default
    ../../modules/home/hyprland.nix
    ../../modules/home/dms.nix
    ../../modules/home/firefox.nix
    ../../modules/home/must-haves.nix
    ../../modules/home/hyprshell.nix
  ];

  home = {
    username = "qt1";
    homeDirectory = "/home/qt1";
    stateVersion = "26.05";
    packages = [ pkgs.deezer-desktop ];

    pointerCursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
