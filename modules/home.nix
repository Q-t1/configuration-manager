{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home = {
    username = "qt1";
    homeDirectory = "/home/qt1";
    stateVersion = "26.05";
  };

  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      wallpaper = {
        enabled = true;
        default.path = "/path/to/wallpapers/wallpaper.png";
      };
    };
  };

}
