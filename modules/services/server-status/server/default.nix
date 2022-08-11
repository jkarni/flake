{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.status-server;
  serverConfig = pkgs.writeText "serverConfig.json" (builtins.readFile ./serverConfig.json);
in
{
  options = {
    services.status-server.enable = lib.mkEnableOption "status-server service";
  };

  config = lib.mkIf cfg.enable {

    system.activationScripts.SyncServerStatusDNS = lib.stringAfter [ "var" ] ''
      RED='\033[0;31m'
      NOCOLOR='\033[0m'

      if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
        echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
        echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
      else
        ${pkgs.cloudflare-dns-sync} top.${config.networking.domain}
      fi
    '';


    systemd.services.serverstatus-server = {
      description = "serverstatus-server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # install WebUI once
      preStart = ''
        if [ ! -d /var/lib/ServerStatus/hotaru-theme/json ]
        then
          mkdir -p /var/lib/ServerStatus/
          ${pkgs.wget}/bin/wget -P /var/lib/ServerStatus/ https://github.com/cokemine/hotaru_theme/releases/latest/download/hotaru-theme.zip
          ${pkgs.unzip}/bin/unzip -d /var/lib/ServerStatus/ /var/lib/ServerStatus/hotaru-theme.zip
        fi
      '';

      serviceConfig = {
        ExecStart = "${pkgs.ServerStatus-Server}/bin/sergate  --config=${serverConfig} --web-dir=/var/lib/ServerStatus/hotaru-theme  --port 35601";
      };
    };


    virtualisation.oci-containers.containers = {
      "httpserver" = {
        image = "capriciousduck/http-server:arm64";
        volumes = [
          "/var/lib/ServerStatus/hotaru-theme:/public"
        ];
        extraOptions = [
          "--label"
          "traefik.enable=true"

          "--label"
          "traefik.http.routers.httpserver.rule=Host(`top.${config.networking.domain}`)"
          "--label"
          "traefik.http.routers.httpserver.entrypoints=web"
          "--label"
          "traefik.http.routers.httpserver.middlewares=web-redirect@file"

          "--label"
          "traefik.http.routers.websecure-httpserver.rule=Host(`top.${config.networking.domain}`)"
          "--label"
          "traefik.http.routers.websecure-httpserver.entrypoints=websecure"
        ];
      };
    };


  };
}
