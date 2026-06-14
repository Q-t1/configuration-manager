{ modulesPath, lib, ... } @ args:
{
  imports = [
    ./disk-config.nix
  ];

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
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
      vim
      gnutar
      git
    ];
    hashedPassword = "$6$mX3KybIzvY4Kcl/Y$LN5lcc5iefNmKDSitgRd84GXdJ5VMup/DPLojazNMD8Yj/AAuRxnd0CsYxEmmQX7TEMHBA7AbN96yMWQ25IKY0";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?


}