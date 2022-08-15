{ pkgs
, lib
, config
, ...
}:
let
  serverConfig = pkgs.writeText "serverConfig.json" (builtins.readFile ./serverConfig.json);
in
{
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

  services.nginx.enable = true;
  services.nginx.virtualHosts."top.${config.networking.domain}" = {
    root = "/var/lib/ServerStatus/hotaru-theme";
  };

}
