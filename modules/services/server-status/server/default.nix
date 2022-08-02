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

    system.activationScripts."installWebUI" = pkgs.lib.stringAfter [ "var" ] ''
      [ ! -d /var/lib/ServerStatus/hotaru-theme ] && mkdir -p /var/lib/ServerStatus/; wget https://github.com/cokemine/hotaru_theme/releases/latest/download/hotaru-theme.zip; unzip /var/lib/ServerStatus/hotaru-theme.zip -d /var/lib/ServerStatus/web
  
    '';

    systemd.services.serverstatus-server = {
      description = "serverstatus-server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.ServerStatus-Server}/sergate  --config=${serverConfig} --web-dir=/var/lib/ServerStatus/hotaru-theme  --port 35601";
      };
    };

    services.nginx.enable = true;
    services.nginx.virtualHosts."top.mlyxshi.com" = {
      root = "/var/lib/ServerStatus/hotaru-theme";
    };
  };
}
