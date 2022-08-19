{ config, ... }: {
  imports = [
    ./hardware.nix
    ../../os/nixos
    ../../os/nixos/desktop.nix
    ../../home/home-manager.nix

    ../../services/ssh-config.nix
  ];

  home-manager.users.root = import ../../home;
  home-manager.users.dominic = import ../../home/sway.nix;

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };

  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };

  sops.secrets.restic-env = { };
  sops.secrets.restic-password = { };

  services.restic.backups."firefox-profile" = {
    environmentFile = config.sops.secrets.restic-env.path;
    passwordFile = config.sops.secrets.restic-password.path;
    extraBackupArgs = [
      "--exclude=chrome" # managed by hm soft link
    ];
    paths = [ "/home/dominic/.mozilla/firefox/default" ];
    timerConfig.OnCalendar = "03:00";
    pruneOpts = [ "--keep-last 2" ];
  };
}
