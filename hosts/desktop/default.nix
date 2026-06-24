{ pkgs, inputs, ... }:
let
  zen-browser = (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default).overrideAttrs (_: {
    nativeBuildInputs = [ pkgs.makeWrapper pkgs.copyDesktopItems pkgs.wrapGAppsHook3 ];
  });
in
{
  imports = [
    ./disk-config.nix
  ];

  networking.hostName = "desktop-qt1";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  console.keyMap = "fr";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."qt1" = {
    isNormalUser = true;
    description = "Quentin";
    home = "/home/qt1";
    shell = pkgs.bash;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      quickshell
      vim
      gnutar
      git
      zed-editor
      ghostty
      claude-code
      zen-browser
    ];
    hashedPassword = "$6$mX3KybIzvY4Kcl/Y$LN5lcc5iefNmKDSitgRd84GXdJ5VMup/DPLojazNMD8Yj/AAuRxnd0CsYxEmmQX7TEMHBA7AbN96yMWQ25IKY0";
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBqSbEXb7nSmu2vAl99sDH0Di4YMH0foOiv0XSywfcIAWqqXE7twoateg/1AiVoNSE5nHfLL791XxUcQ5lPYHLM= qt1@nixos"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtASdfLMatnUWsdJIjIvIXqXrnmABAznN/6mji1/rzRLqrusduqahyi4htTRvOuue3vrhUqeywiRTNTpzthfhVqeF5WehE1wAPkbgGwAvxC8ltqLPza6KkfZF0WXdXj/MsKJDTJUwui+acbyJocuMz0teJOhURoaEetXzr+ffj6P9Txz7uX6KN8D2DYGi9WvG8QPdlF/89f5vtCx4GFrKkdSET+yNC3PEcf+X8wDoL+ztuvcTGLb4rC42NzLJ82VCAYZ6KS085s8GD+lcgU/jxpRUeCVoY7Ciym/VKs2oxVsyM45fP+d33BJmqV+WGgVLHz0T4y05HOS6CBLObbXZYLfDg7jNl/MVxVktNRfvPLr23z8IvUL1DR8lHIqc6jesFMe8W5PuaoxwzQIhRl8ywGT/rVq1btMiS41mqo/86pZAFtehTt04A3GbMVGB7NNO3tmaVbUlr/aSFdB/hLr0pU3uuZQsHCipZ/3+IGs7erU1r2VVNhnxd/JcDJEVstd8= quentin@MacBook-Air-de-Quentin.local"
    ];
  };

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

  environment.shellAliases.zen-browser = "zen";

  environment.etc."zen-browser/policies/policies.json".text = builtins.toJSON {
    policies = {
      Homepage = {
        URL = "https://www.google.com";
        StartPage = "homepage";
      };
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Google";
      DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
    };
  };

  programs.niri.enable = true;
  # Keep this, as per NixOS wiki
  systemd.user.services.niri.enableDefaultPath = false;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
