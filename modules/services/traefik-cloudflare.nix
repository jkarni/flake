{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.traefik-cloudflare;
in
{
  options = {
    services.traefik-cloudflare.enable = lib.mkEnableOption "traefik-cloudflare service";
  };

  config = lib.mkIf cfg.enable {

    systemd.services.traefik.serviceConfig.EnvironmentFile = config.sops.secrets.traefik-cloudflare-env.path;

    services.traefik = {
      enable = true;
      group = "podman"; # podman backend

      dynamicConfigOptions = {
        tls.options.default = {
          minVersion = "VersionTLS12";
          sniStrict = true;
        };

        http.middlewares = {
          web-redirect.redirectScheme.scheme = "https";
        };
      }; # dynamicConfigOptions

      staticConfigOptions = {
        api.insecure = true; # dashboard

        providers.docker.endpoint = "unix:///run/podman/podman.sock";      
        providers.docker.exposedByDefault = false;

        entryPoints = {
          web = {
            address = ":80";
          };
          websecure = {
            address = ":443";
            http.tls.certResolver = "letsencrypt";
          };
        };

        certificatesResolvers.letsencrypt.acme = {
          dnsChallenge.provider = "cloudflare";
          email = "blackhole@${config.networking.domain}";
          storage = "${config.services.traefik.dataDir}/acme.json"; # "/var/lib/traefik/acme.json"
        };

      }; # staticConfigOptions
    }; # services.traefik
  };
}
