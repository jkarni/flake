{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.status-server;
  serverEnv =  pkgs.writeText "serverEnv.conf" (builtins.readFile ./serverEnv.conf);
  serverConfig = pkgs.writeText "serverConfig.json" (builtins.readFile ./serverConfig2.json);
in
{
  options = {
    services.status-server.enable = lib.mkEnableOption "status-server service";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      ServerStatus-Server
    ];

    # EnvironmentFile=/usr/local/ServerStatus/server/config.conf
    # ExecStart=/usr/local/ServerStatus/server/sergate --config=/usr/local/ServerStatus/server/config.json --web-dir=/usr/local/ServerStatus/web --port $PORT


    systemd.services.serverstatus-server = {
      description = "serverstatus-server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        #EnvironmentFile = ${serverEnv};
        ExecStart = "${pkgs.ServerStatus-Server}/sergate  --config=${serverConfig} --web-dir=/var/lib/ServerStatus/hotaru-theme  --port 35601";
      };
    };


  };
}
