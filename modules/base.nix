{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
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

  boot.initrd.kernelModules = [ "" ];

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
    trusted-users = [ "root" "quentin" ];
  };

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.sbctl
    pkgs.tpm2-tools
    pkgs.tpm2-luks
    pkgs.curl
    pkgs.gitMinimal
    pkgs.bash
    pkgs.libtss2
  ];

  users.users.qt1.shell = pkgs.bash;

  console.keyMap = "fr";

  users.users.qt1.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBqSbEXb7nSmu2vAl99sDH0Di4YMH0foOiv0XSywfcIAWqqXE7twoateg/1AiVoNSE5nHfLL791XxUcQ5lPYHLM= qt1@nixos"
  ];

  system.stateVersion = "26.05";
}
