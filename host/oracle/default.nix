{
  imports = [
    ./hardware.nix
    ../../os/nixos
    ../../home/home-manager.nix

    ../../script/cloudflare-dns-sync.nix
  ];

  home-manager.users.root = import ../../home;

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.tmpOnTmpfs = true;

  # podman
  virtualisation.podman.enable = true;

  # docker
  # for traefik discovery
  # virtualisation.docker.enable = true;
  # virtualisation.oci-containers.backend = "docker";


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
