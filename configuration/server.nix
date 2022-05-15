{ config, pkgs, ... }:{
  
  imports = [
    ./common.nix
  ];  

  networking = {
    useNetworkd = true;
    useDHCP = true;
    firewall.enable = false;
    hostName = "nixos";
  };

  


}
