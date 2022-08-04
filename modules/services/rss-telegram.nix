{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.rss-telegram;
  RssConfigDir = "/var/lib/rss";
in
{
  options = {
    services.rss-telegram.enable = lib.mkEnableOption "rss-telegram service";
  };

  config = lib.mkIf cfg.enable {

    sops.secrets.tg-rss-env = { };

    system.activationScripts.makeRssConfigDir = lib.stringAfter [ "var" ] ''
      [ ! -d ${RssConfigDir} ] && mkdir -p ${RssConfigDir}
    '';

    system.activationScripts.SyncRssDNS = lib.stringAfter [ "var" ] ''
      RED='\033[0;31m'
      NOCOLOR='\033[0m'

      if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
        echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
        echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
      else
        ${pkgs.cloudflare-dns-sync} rss.mlyxshi.com
      fi
    '';

    virtualisation.oci-containers.containers = {
      "rss-telegram" = {
        image = "rongronggg9/rss-to-telegram";
        volumes = [ "${RssConfigDir}:/app/config" ];
        environmentFiles = [ config.sops.secrets.tg-rss-env.path ];
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
      pruneOpts = [ "--keep-last 2" ];
    };
  };
}
