{ config, pkgs, lib, ... }:
let
  NCRaw = pkgs.writeText "NCRaw" (builtins.readFile ./NCRaw.js);
in
{

  sops.secrets.telegram-env = { };

  systemd.services.bangumi = {
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs}/bin/node ${NCRaw}";
      EnvironmentFile = [ config.sops.secrets.telegram-env.path ];
    };
    wantedBy = [ "multi-user.target" ];
  };

}
