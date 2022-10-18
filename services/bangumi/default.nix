{ config, pkgs, lib, ... }:
let
  NCRaw = pkgs.writeText "NCRaw.js" (builtins.readFile ./NCRaw.js);
  InfuseRedirect = pkgs.writeText "InfuseRedirect.js" (builtins.readFile ./InfuseRedirect.js);
in
{

  sops.secrets.telegram-env = { };

  systemd.services.bangumi-ncraw = {
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs}/bin/node ${NCRaw}";
      EnvironmentFile = [ config.sops.secrets.telegram-env.path ];
      # Restart="always";
      # RestartSec=10;
    };
    wantedBy = [ "multi-user.target" ];
  };

  # port 4666
  systemd.services.bangumi-infuseRedirect = {
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs}/bin/node ${InfuseRedirect}";
    };
    wantedBy = [ "multi-user.target" ];
  };


  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers.infuseRedirect = {
          rule = "Host(`bangumi.${config.networking.domain}`)";
          entryPoints = [ "web" ];
          service = "infuseRedirect";
        };

        services.infuseRedirect.loadBalancer.servers = [{
          url = "http://127.0.0.1:4666/";
        }];
      };
    };
  };

  system.activationScripts.cloudflare-dns-sync-bangumi = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} bangumi.${config.networking.domain}
    '';
  };

}
