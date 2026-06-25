{ ... }:
{
  imports = [
    ../../modules/home/niri.nix
    ../../modules/home/noctalia.nix
    ../../modules/home/firefox.nix
  ];

  home = {
    username = "qt1";
    homeDirectory = "/home/qt1";
    stateVersion = "26.05";
  };
}
