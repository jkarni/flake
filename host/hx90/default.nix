{config, ...}: {
  imports = [
    ./hardware.nix
    ../../os/nixos
    ../../home/home-manager.nix
  ];

  home-manager.users.root = import ../../home;
  home-manager.users.dominic = import ../../home/sway.nix;

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };

  services.restic.backups."firefox-profile" = {
    extraBackupArgs = [
      "--exclude=chrome"
    ];
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [
      "/home/dominic/.mozilla/firefox/default"
    ];
    repository = "rclone:googleshare:backup";
    timerConfig.OnCalendar = "daily";
    pruneOpts = ["--keep-last 2"];
  };
}
