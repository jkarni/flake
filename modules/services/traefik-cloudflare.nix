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

    # https://traefik.io/blog/traefik-2-0-docker-101-fc2893944b9d/
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
          # https://tool.oschina.net/htpasswd
          auth.basicauth.users = "admin:$apr1$DImGj.4T$L0bHKQ1csdPlxURxWZWc/1";
        };

        http.routers.api = {
          rule = "Host(`${config.networking.fqdn}`)";
          service = "api@internal";
          entrypoints = "web";
          middlewares = "auth";
        };

      }; # dynamicConfigOptions

      staticConfigOptions = {
        api = { };

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
