{ pkgs, ... }:
{
  programs.hyprshell = {
    enable = true;
    package = pkgs.hyprshell;

    systemd.enable = false;

    settings.windows = {
      enable = true;
      overview.enable = true;
      switch = {
        enable = true;
        modifier = "alt";
      };
    };
  };
}
