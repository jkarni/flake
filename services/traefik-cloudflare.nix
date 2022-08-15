{ pkgs, lib, config, ... }:
{
  sops.secrets.traefik-cloudflare-env = { };
  systemd.services.traefik.serviceConfig.EnvironmentFile = config.sops.secrets.traefik-cloudflare-env.path;

  # https://traefik.io/blog/traefik-2-0-docker-101-fc2893944b9d/
  services.traefik = {
    enable = true;
    group = "podman"; # podman backend

    dynamicConfigOptions = {

      http.middlewares = {
        web-redirect.redirectScheme.scheme = "https";
        # https://tool.oschina.net/htpasswd
        auth.basicauth = {
          users = "{{ env `TRAEFIK_AUTH` }}";
          removeheader = true;
        };
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

      providers.docker = {
        endpoint = "unix:///run/podman/podman.sock";
        exposedByDefault = false;
      };

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
}