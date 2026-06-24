{
  imports = [
    ./disk-config.nix
    ../../modules/audio.nix
    ../../modules/graphics.nix
    ../../modules/locale.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/zen.nix
    ../../modules/fonts.nix
  ];

  networking.hostName = "desktop-qt1";

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "qt1";
        email = "quentin.roccia@gmail.com";
      };
      core.autocrlf = "input";
      core.eol = "lf";
      push.autoSetupRemote = true;
      push.default = "current";
      init.defaultBranch = "main";
    };
  };

  programs.niri.enable = true;
  systemd.user.services.niri.enableDefaultPath = false;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
