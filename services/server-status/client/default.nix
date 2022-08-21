{ pkgs
, lib
, config
, ...
}:
let
  serverstatus-client-script = pkgs.writeScript "serverstatus-client-script" (''
    SERVER = "top.${config.networking.domain}"
    PORT = 35601
    USER = "${config.networking.hostName}"
    PASSWORD = "${config.networking.hostName}"
    INTERVAL = 1
  ''
  + builtins.readFile ./serverstatus-client.py);
in
{
  services.vnstat.enable = true;

  systemd.services.serverstatus-client = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python ${serverstatus-client-script}";
    };
  };

}
