{ config, pkgs, lib, ... }: {

  # rss to muted tg bot  <-- only for tracking Nixpkgs PR
  sops.secrets.miniflux-env = { };
  sops.secrets.miniflux-db-env = { };

  virtualisation.oci-containers.containers = {

    "miniflux" = {
      image = "miniflux/miniflux";
      dependsOn = [ "miniflux-db" ];
      environmentFiles = [ config.sops.secrets.miniflux-env.path ];
      environment = {
        CREATE_ADMIN = "1";
        RUN_MIGRATIONS = "1";
        POLLING_FREQUENCY = "10";
        POLLING_PARSING_ERROR_LIMIT = "0";
      };
      extraOptions = [

        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.websecure-miniflux.rule=Host(`miniflux-silent.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-miniflux.entrypoints=websecure"
      ];
    };

    "miniflux-db" = {
      image = "postgres";
      volumes = [
        "/var/lib/miniflux-db:/var/lib/postgresql/data"
      ];
      environmentFiles = [ config.sops.secrets.miniflux-db-env.path ];
    };

  };

  systemd.services.podman-miniflux-db.serviceConfig.StateDirectory = "miniflux-db";

  system.activationScripts.cloudflare-dns-sync-miniflux = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} miniflux-silent.${config.networking.domain}
    '';
  };

}
