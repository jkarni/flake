{ config, pkgs, ... }: {

  imports = [
    ./common.nix
  ];

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
    nameservers = [ "1.1.1.1" ];
  };

  # systemd-resolved
  services.resolved.enable = true;
  services.resolved.dnssec = "false";

}
