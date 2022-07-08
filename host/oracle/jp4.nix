{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./default.nix
  ];

  services.bt.enable = true;

  services.restic.backups."bt-backup" = {
    extraBackupArgs = [
      "--exclude=qBittorrent/downloads"
    ];
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [
      "/var/lib/qbittorrent-nox"
    ];
    repository = "rclone:googleshare:backup";
    timerConfig.OnCalendar = "daily";
  };
}
