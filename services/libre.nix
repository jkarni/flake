{ config, pkgs, lib, ... }:
let
  # https://github.com/iv-org/invidious/blob/master/config/config.example.yml 
  INVIDIOUS_CONFIG = ''
    database_url: postgres://kemal:kemal@invidious-db:5432/invidious
    check_tables: true
    external_port: 443
    domain: youtube.${config.networking.domain}
    https_only: true
    registration_enabled: false

    default_user_preferences:
      autoplay: true
      video_loop: true
      quality: dash
      quality_dash: best
      default_home: Search
      feed_menu: []
  '';
in
{

  services.traefik.dynamicConfigOptions = {
    http.routers = {
      nitter.rule = "Host(`twitter.${config.networking.domain}`)";
      nitter.entrypoints = "websecure";
      nitter.service = "nitter";
    };

    http.services = {
      nitter.loadBalancer.servers = [{ url = "http://localhost:8083"; }];
    };
  };


  services.nitter = {
    enable = true;
    preferences = {
      replaceTwitter = config.services.nitter.server.hostname;
      infiniteScroll = true;
      hlsPlayback = true;
      theme = "Auto";
    };
    server = {
      address = "127.0.0.1";
      https = true;
      hostname = "twitter.${config.networking.domain}";
      port = 8083;
    };
  };


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

    "invidious" = {
      image = "quay.io/invidious/invidious:latest-arm64";
      dependsOn = [ "invidious-db" ];
      environment = {
        inherit INVIDIOUS_CONFIG;
      };
      extraOptions = [
        "--label"
        "traefik.enable=true"
        "--label"
        "traefik.http.routers.websecure-invidious.rule=Host(`youtube.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-invidious.entrypoints=websecure"

        "--label"
        "io.containers.autoupdate=registry"
      ];
    };


    "invidious-db" = {
      image = "postgres";
      volumes = [
        "/var/lib/invidious-db:/var/lib/postgresql/data"
      ];
      environment = {
        # public service
        POSTGRES_DB = "invidious";
        POSTGRES_USER = "kemal";
        POSTGRES_PASSWORD = "kemal";
      };
    };

  };

  systemd.services.podman-invidious-db.serviceConfig.StateDirectory = "invidious-db";

  systemd.services.podman-libreddit.environment = {
    PODMAN_SYSTEMD_UNIT = "%n";
  };
  systemd.services.podman-invidious.environment = {
    PODMAN_SYSTEMD_UNIT = "%n";
  };

  system.activationScripts.cloudflare-dns-sync-libre = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} reddit.${config.networking.domain}
      ${pkgs.cloudflare-dns-sync} youtube.${config.networking.domain}
      ${pkgs.cloudflare-dns-sync} twitter.${config.networking.domain}
    '';
  };

}
