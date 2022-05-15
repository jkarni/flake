{ config, pkgs, ... }:{
  
  imports = [
    ./common.nix
  ];  

  time.timeZone = "America/Los_Angeles";

  networking = {
    useNetworkd = true;
    useDHCP = true;
    firewall.enable = false;
    hostName = "nixos";
  };

  


}
