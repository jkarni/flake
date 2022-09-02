{ config, pkgs, lib, ... }: {

  virtualisation.oci-containers.containers = {

    "libreddit" = {
      image = "spikecodes/libreddit:arm";
      environment = {
        LIBREDDIT_DEFAULT_WIDE = "on";
        LIBREDDIT_DEFAULT_SHOW_NSFW = "on";
        LIBREDDIT_DEFAULT_USE_HLS = "on";
      };
      extraOptions = [
        "--no-healthcheck" # libreddit default healthcheck always fail which will cause traefik omit it.
        "--label"
        "traefik.enable=true"
        "--label"
        "traefik.http.routers.websecure-libreddit.rule=Host(`reddit.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-libreddit.entrypoints=websecure"

        "--label"
        "io.containers.autoupdate=registry"
      ];
    };

  };


  systemd.services.podman-libreddit.environment = {
    PODMAN_SYSTEMD_UNIT = "%n";
  };

  system.activationScripts.cloudflare-dns-sync-libre = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} reddit.${config.networking.domain}
    '';
  };

}
