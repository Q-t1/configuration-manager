{ modulesPath, config, inputs, lib, pkgs, ... } @ args:
{
  imports = [
    ./disk-config.nix
  ];

  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  networking.hostName = "desktop-qt1";
  networking.wireless.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
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

  # Enable graphics
  hardware.graphics.enable = true;

  # Set NVIDIA as video driver
  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA driver settings
  hardware.nvidia = {
    # RTX 20-series+ supports open module (required for driver 560+)
    open = true;
    # Enable kernel mode setting (required for Wayland)
    modesetting.enable = true;
    # Enable NVIDIA settings tool
    nvidiaSettings = true;
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable sound with pipewire.
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
    description = "Compte de Quentin";
    home = "/home/qt1";
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
      alacritty
    ];
    hashedPassword = "$6$mX3KybIzvY4Kcl/Y$LN5lcc5iefNmKDSitgRd84GXdJ5VMup/DPLojazNMD8Yj/AAuRxnd0CsYxEmmQX7TEMHBA7AbN96yMWQ25IKY0";
    openssh.authorizedKeys.keys = [
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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "qt1";
      };
    };
  };

  # Recommended by niri docs when using the user service
  systemd.user.services.niri.enableDefaultPath = false;

  # Noctalia package
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.system}.default
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "26.05";

}
