{
  imports = [
    ./hardware.nix
    ../../os/nixos
    ../../home/home-manager.nix

    ../../script/cloudflare-dns-sync.nix
    ../../modules/services/server-status/client
    ../../modules/services/shadowsocks-rust.nix
    ../../modules/services/ssh-config.nix
  ];

  home-manager.users.root = import ../../home;

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.tmpOnTmpfs = true;

  virtualisation.podman.enable = true;
  # unlike docker, to enable dns resolution between different containers, we need enable dnsname plugin under podman --> https://github.com/containers/dnsname 
  virtualisation.podman.defaultNetwork.dnsname.enable =true;

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
