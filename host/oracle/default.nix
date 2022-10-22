{
  imports = [
    ./hardware.nix
    ../../os/nixos/server.nix
    ../../home/home-manager.nix

    ../../script/cloudflare-dns-sync.nix
    ../../services/server-status/client
    ../../services/shadowsocks-rust.nix
    ../../services/ssh-config.nix
  ];

  home-manager.users.root = import ../../home;
  
  virtualisation.podman.enable = true;
  # unlike docker, to enable dns resolution between different containers, we need enable dnsname plugin under podman --> https://github.com/containers/dnsname 
  virtualisation.podman.defaultNetwork.dnsname.enable = true;

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };

  # Workaround for fixing timeout issue
  # manually reboot once
  systemd.network.wait-online.anyInterface = true;

  systemd.network.networks = {
    dhcp = {
      name = "enp0s3";
      DHCP = "yes";
    };
  };
}
