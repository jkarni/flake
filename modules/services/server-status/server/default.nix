{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.status-server;
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

    systemd.services.serverstatus-server = {
      description = "serverstatus-server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.ServerStatus-Server}/sergate  --config=${serverConfig} --web-dir=/var/lib/ServerStatus/hotaru-theme  --port 35601";
      };
    };


    # listen 80;

    # server_name test.sharqa.com;

    # root /home/linuxhint/www;

    # index index.html;


    services.nginx.enable = true;
    services.nginx.virtualHosts."top.mlyxshi.com" = {
      root = "/var/lib/ServerStatus/hotaru-theme";
    };


  };
}
