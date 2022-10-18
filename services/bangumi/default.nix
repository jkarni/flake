{ config, pkgs, lib, ... }:
let
  NCRaw = pkgs.writeText "NCRaw.js" (builtins.readFile ./NCRaw.js);
in
{

  sops.secrets.telegram-env = { };

  systemd.services.bangumi = {
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs}/bin/node ${NCRaw}";
      EnvironmentFile = [ config.sops.secrets.telegram-env.path ];
      # Restart="always";
      # RestartSec=10;
    };
    wantedBy = [ "multi-user.target" ];
  };

}
