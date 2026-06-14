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
    "virtio_blk"      # KVM disque
    "virtio_pci"      # KVM PCIe
    "virtio_scsi"     # KVM SCSI
    "vmw_pvscsi"      # VMware (optionnel)
    "sd_mod"          # Générique SCSI disk
    "sr_mod"          # Générique CD-ROM
    "ahci"            # Générique SATA
    "xhci_pci"        # Générique USB 3.0
    "kvm_intel"       # Virtualisation Intel
  ];

  boot.initrd.kernelModules = [ "virtio_scsi" ];

  boot.kernelParams = [ "module.sig_enforce=0" ];

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

  users.users.root.shell = pkgs.bash;

  console.keyMap = "fr";

  users.users.root.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBqSbEXb7nSmu2vAl99sDH0Di4YMH0foOiv0XSywfcIAWqqXE7twoateg/1AiVoNSE5nHfLL791XxUcQ5lPYHLM= qt1@nixos"
  ];

  system.stateVersion = "25.11";
}
