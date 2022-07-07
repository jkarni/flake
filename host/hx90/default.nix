{
  imports = [
    ./hardware.nix
    ../../os/nixos
    ../../home/home-manager.nix
  ];

  home-manager.users.root = import ../../home;
  home-manager.users.dominic = import ../../home/sway.nix;

  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };

  sops.secrets.restic-password = { };
  sops.secrets.rclone-config = { };

  services.restic.backups."firefox-profile" = {
    extraBackupArgs = [
      "--exclude-file=/home/dominic/.mozilla/firefox/default/chrome"
    ];
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [
      "/home/dominic/.mozilla/firefox/default"
    ];
    repository = "rclone:googleshare:backup";
    timerConfig.OnCalendar = "daily";
  };



}
