{ modulesPath, lib, ... } @ args:
{
  imports = [
    ./disk-config.nix
  ];

  networking.hostName = "nixbuilder";

  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = false;
  networking.interfaces.enp6s0.ipv4.addresses = [
    {
      address = "10.0.0.110";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = {
    address = "10.0.0.1";
    interface = "enp6s0";
  };
  networking.nameservers = [ "10.0.0.1" ];

  users.users.root.hashedPassword = "$6$KAgVHbUmU6mp7fOk$nM5TAmNm0EVy.1I/e1mu.VAAXiWsMwLG4XDOgsBc1NlJgDuz3wHTs45.bj2d.F2OmVxirLks/JGz7XUiPE0p9/";
}
