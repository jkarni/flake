{ pkgs, config, ... }: {
  imports = [
    ./hardware.nix
    ../../os/nixos/server.nix
    ../../home/home-manager.nix

    ../../services/server-status/client
    ../../services/proxy/shadowsocks-rust.nix
    ../../services/ssh-config.nix
    ../../script/cloudflare-dns-sync.nix
  ];

  home-manager.users.root = import ../../home;

  system.activationScripts.cloudflare-dns-sync-host = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync}/bin/cloudflare-dns-sync ${config.networking.fqdn}
    '';
  };

  networking.usePredictableInterfaceNames = false;

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };

  systemd.network.wait-online.anyInterface = true;
  systemd.network.networks = {
    dhcp = {
      name = "eth0";
      DHCP = "yes";
    };
  };

}
