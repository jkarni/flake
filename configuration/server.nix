{ config, pkgs, ... }:{
  
  imports = [
    ./common.nix
  ];  

  networking = {
    useNetworkd = true;
    useDHCP = false;
    interfaces.ens3.useDHCP = true;
    firewall.enable = false;
    hostName = "nixos";
  };

  


}
