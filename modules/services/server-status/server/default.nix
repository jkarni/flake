{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.status-server;
  serverConfig = pkgs.writeText "serverConfig.json" (builtins.readFile ./serverConfig.json);
  install-serverstatus-webui = pkgs.writeShellScript "install-serverstatus-webui" ''
    if [ ! -d /var/lib/ServerStatus/hotaru-theme/json ]
    then
      mkdir -p /var/lib/ServerStatus/
      ${pkgs.wget}/bin/wget -P /var/lib/ServerStatus/ https://github.com/cokemine/hotaru_theme/releases/latest/download/hotaru-theme.zip
      ${pkgs.unzip}/bin/unzip -d /var/lib/ServerStatus/ /var/lib/ServerStatus/hotaru-theme.zip
    fi
  '';
in
{
  options = {
    services.status-server.enable = lib.mkEnableOption "status-server service";
  };

  config = lib.mkIf cfg.enable {

    systemd.services.install-serverstatus-webui = {
      description = "install-serverstatus-webui";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      before = [ "serverstatus-server.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash ${install-serverstatus-webui}";
      };
    };

    systemd.services.serverstatus-server = {
      description = "serverstatus-server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.ServerStatus-Server}/bin/sergate  --config=${serverConfig} --web-dir=/var/lib/ServerStatus/hotaru-theme  --port 35601";
      };
    };

    services.nginx.enable = true;
    services.nginx.virtualHosts."top.mlyxshi.com" = {
      root = "/var/lib/ServerStatus/hotaru-theme";
    };
  };
}
