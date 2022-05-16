{ config, pkgs, ... }:{
  
  imports = [
    ./common.nix
  ];  

  networking = {
    useNetworkd = true;
    useDHCP = false;
    interfaces.enp0s3.useDHCP = true;
    firewall.enable = false;
    hostName = "nixos";
  };

  


}
