{ config, pkgs, ... }:{
  
  imports = [
    ./common.nix
  ];  

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
    hostName = "nixos";
  };

}
