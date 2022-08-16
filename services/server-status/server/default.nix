{ pkgs
, lib
, config
, ...
}:
let
  serverConfig = pkgs.writeText "serverConfig.json" (builtins.readFile ./serverConfig.json);
in
{

  systemd.services.serverstatus-server = {
    description = "serverstatus-server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      if [ ! -d /var/lib/ServerStatus/hotaru-theme/json ]
      then
        mkdir -p /var/lib/ServerStatus/
        ${pkgs.wget}/bin/wget -P /var/lib/ServerStatus/ https://github.com/cokemine/hotaru_theme/releases/latest/download/hotaru-theme.zip
        ${pkgs.unzip}/bin/unzip -d /var/lib/ServerStatus/ /var/lib/ServerStatus/hotaru-theme.zip
      fi

      ${pkgs.cloudflare-dns-sync} top.${config.networking.domain}
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
