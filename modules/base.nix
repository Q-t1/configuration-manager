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
  };

  boot.initrd.services.lvm.enable = true;

  boot.loader.grub.enable = false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      # Automatically reboot to enroll the keys in the firmware
      autoReboot = true;
    };
  };

  boot.initrd.systemd.enable = true;

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.sbctl
    pkgs.curl
    pkgs.gitMinimal
    pkgs.bash
  ];

  users.users.qt1.shell = pkgs.bash;

  console.keyMap = "fr";

  users.users.qt1.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBqSbEXb7nSmu2vAl99sDH0Di4YMH0foOiv0XSywfcIAWqqXE7twoateg/1AiVoNSE5nHfLL791XxUcQ5lPYHLM= qt1@nixos"
  ];

  system.stateVersion = "26.05";
}
