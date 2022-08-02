{ config
, pkgs
, ...
}:
let
  status-client = pkgs.writeScript "status-client" (''
    SERVER = "jp1.mlyxshi.com"
    PORT = 35601
    USER = "${config.networking.hostName}"
    PASSWORD = "${config.networking.hostName}"
    INTERVAL = 1  
  
  ''
  + builtins.readFile ./status-client.py);

in
{
  imports = [
    ./default.nix
  ];

  services.qbittorrent-nox.enable = true;


  systemd.services.serverstatus-client = {
    description = "serverstatus-client";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python ${status-client}";
    };
  };

}
