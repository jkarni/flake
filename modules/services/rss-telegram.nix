{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.rss-telegram;
  RssConfigDir = "/var/lib/rss";
  RssEnv = "/tmp/rss-telegram.env";
in {
  options = {
    services.rss-telegram.enable = lib.mkEnableOption "rss-telegram service";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.tg-userid = {};
    sops.secrets.tg-rss-token = {};
    sops.secrets.telegraph-token = {};

    system.activationScripts.makeRssConfigDir = lib.stringAfter ["var"] ''
      [ ! -d ${RssConfigDir} ] && mkdir -p ${RssConfigDir}
    '';

    system.activationScripts.generateSecretEnv = lib.stringAfter ["var"] ''
      echo MANAGER=$(cat ${config.sops.secrets.tg-userid.path}) > ${RssEnv}
      echo TOKEN=$(cat ${config.sops.secrets.tg-rss-token.path}) >> ${RssEnv}
      echo TELEGRAPH_TOKEN=$(cat ${config.sops.secrets.telegraph-token.path}) >> ${RssEnv}
    '';

    virtualisation.oci-containers.containers = {
      "rss-telegram" = {
        image = "rongronggg9/rss-to-telegram";
        volumes = ["${RssConfigDir}:/app/config"];

        environmentFiles = [
          "${RssEnv}"
        ];
      };

      #Port 1200
      "rsshub" = {
        image = "diygod/rsshub";
        extraOptions = [
          "--network=host"
        ];
      };

    };

    services.restic.backups."rss-telegram-backup" = {
      passwordFile = config.sops.secrets.restic-password.path;
      rcloneConfigFile = config.sops.secrets.rclone-config.path;
      paths = [
        "${RssConfigDir}"
      ];
      repository = "rclone:googleshare:backup";
      timerConfig.OnCalendar = "daily";
      pruneOpts = ["--keep-last 2"];
    };
  };
}
