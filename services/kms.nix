{ config, pkgs, lib, ... }: {

  virtualisation.oci-containers.containers = {
    "kms-server" = {
      image = "mikolatero/vlmcsd";
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.kms.rule=Host(`kms.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.kms.entrypoints=web"
      ];
    };
  };

  system.activationScripts.cloudflare-dns-sync-kms = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} kms.${config.networking.domain}
    '';
  };

}
