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
        api.dashboard = true;
        api.insecure = true;

        # TODO: wait traefik support podman
        # providers.docker.endpoint = "unix:///run/podman/podman.sock";

        entryPoints = {
          web = {
            address = ":80";
          };
          websecure = {
            address = ":443";
            http.tls.certResolver = "zerossl";
          };
        };

        # Compare to letsencrypt, zerossl has a fancy dashboard
        # Under NixOS context, it is very hard to hide zerossl kid and hmac 
        # Anyway, please do not play prank on me! ~~Hope noboby see this~~
        certificatesResolvers.zerossl.acme = {
          caServer = "https://acme.zerossl.com/v2/DV90";
          email = "blackhole@mlyxshi.com";
          storage = config.services.traefik.dataDir + "/acme.json";
          dnsChallenge = {
            provider = "cloudflare";
          };
          eab = {
            kid = "vNX1_fYB1JNTdjDJyPxdyQ";
            hmacEncoded = "aUiEz8TfxcZAW7FxjeHP8T7sG83PnR04Brcv_orQ_DZS1EWhpKoJl5Rh72-Utb3tovwxTj3e0Lylx3DdBbiAxg";
          };
        };

      }; # staticConfigOptions
    }; # services.traefik
  };
}
