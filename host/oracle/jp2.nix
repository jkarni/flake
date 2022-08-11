{ pkgs
, lib
, config
, ...
}:
let
  RssConfigDir = "/var/lib/rss";
in
{

  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;
  
  services.status-server.enable = true;

  services.traefik-cloudflare.enable = true;


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
      ${pkgs.cloudflare-dns-sync} rss.${config.networking.domain}
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
        "--label" "traefik.enable=true"
        "--label" "traefik.http.routers.websecure-rsshub.rule=Host(`rss.${config.networking.domain}`)"
        "--label" "traefik.http.routers.websecure-rsshub.entrypoints=websecure"
      ];
    };
  };

  services.restic.backups."rss-telegram-backup" = {
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [
      "${RssConfigDir}"
    ];
    repository = "rclone:r2:backup";
    timerConfig.OnCalendar = "00:00";
    pruneOpts = [ "--keep-last 2" ];
  };

}
