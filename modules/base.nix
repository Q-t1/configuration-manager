{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [ "kvm-intel" ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.cryptroot = {
    allowDiscards = true;
    preLVM = true;
    # TPM2 unlock via systemd crypttabExtraOpts
    crypttabExtraOpts = [ "tpm2-device=auto" ];
  };

  boot.initrd.services.lvm.enable = true;

  boot.loader.grub.enable = false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };
  };

  boot.initrd.systemd.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "qt1" ];
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "colormix";
      colormix_col1 = "0x00000000";
      colormix_col2 = "0x00110033";
      colormix_col3 = "0x20000000";
      bg = "0x00000000";
      fg = "0x00FFFFFF";
      clock = "%H:%M";
    };
  };

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.sbctl
    pkgs.tpm2-tools
    pkgs.tpm-luks
    pkgs.curl
    pkgs.gitMinimal
    pkgs.bash
    pkgs.tpm2-tss
  ];

  system.stateVersion = "26.05";
}
