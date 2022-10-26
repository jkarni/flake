{ config, pkgs, lib, ... }: {

  virtualisation.oci-containers.containers = {
    "kms-server" = {
      image = "docker.io/mikolatero/vlmcsd";
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.kms.rule=Host(`kms.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.kms.entrypoints=web"

        "--label"
        "io.containers.autoupdate=registry"
      ];
    };
  };

  system.activationScripts.cloudflare-dns-sync-kms = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync}/bin/cloudflare-dns-sync kms.${config.networking.domain}
    '';
  };

}
