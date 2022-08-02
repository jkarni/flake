{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.status-client;
  serverstatus-client-script = pkgs.writeScript "serverstatus-client-script" (''
    SERVER = "top.mlyxshi.com"
    PORT = 35601
    USER = "${config.networking.hostName}"
    PASSWORD = "${config.networking.hostName}"
    INTERVAL = 1  
  ''
  + builtins.readFile ./serverstatus-client.py);
in
{
  options = {
    services.status-client.enable = lib.mkEnableOption "status-client service";
  };

  config = lib.mkIf cfg.enable {

    services.vnstat.enable = true;

    systemd.services.serverstatus-client = {
      description = "serverstatus-client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.python3}/bin/python ${serverstatus-client-script}";
      };
    };


  };
}
