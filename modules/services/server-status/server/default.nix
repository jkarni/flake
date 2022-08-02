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

    virtualisation.oci-containers.containers = {

      "serverstatus-server" = {
        image = "stilleshan/serverstatus";
        ports = [
          "80:80"
          "35601:35601"
        ];
        volumes = [
          "${serverConfig}:/ServerStatus/server/config.json"
        ];
      };
    };

  };
}
