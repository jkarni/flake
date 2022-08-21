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
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      if [ ! -d /var/lib/ServerStatus/hotaru-theme/json ]
      then
        mkdir -p /var/lib/ServerStatus/
        ${pkgs.wget}/bin/wget -P /var/lib/ServerStatus/ https://github.com/cokemine/hotaru_theme/releases/latest/download/hotaru-theme.zip
        ${pkgs.unzip}/bin/unzip -d /var/lib/ServerStatus/ /var/lib/ServerStatus/hotaru-theme.zip
      fi
    '';

    serviceConfig.ExecStart = "${pkgs.ServerStatus-Server}/bin/sergate  --config=${serverConfig} --web-dir=/var/lib/ServerStatus/hotaru-theme  --port 35601";
  };

  system.activationScripts.cloudflare-dns-sync-serverstatus-server = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} top.${config.networking.domain}
    '';
  };

  virtualisation.oci-containers.containers = {
    "nginx" = {
      image = "nginx";
      volumes = [
        "/var/lib/ServerStatus/hotaru-theme:/usr/share/nginx/html"
      ];
      extraOptions = [
        "--label"
        "traefik.enable=true"
        "--label"
        "traefik.http.routers.serverstatus.rule=Host(`top.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.serverstatus.entrypoints=web"
      ];
    };
  };

}
