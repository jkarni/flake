{ config
, pkgs
, lib
, ...
}:
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
  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;
  services.unblock-netease-music.enable = true;

  system.activationScripts.SyncReplaceDNS = lib.stringAfter [ "var" ] ''
    RED='\033[0;31m'
    NOCOLOR='\033[0m'
    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} reddit.${config.networking.domain}
      ${pkgs.cloudflare-dns-sync} youtube.${config.networking.domain}
      ${pkgs.cloudflare-dns-sync} twitter.${config.networking.domain}
      ${pkgs.cloudflare-dns-sync} netease.${config.networking.domain}
    fi
  '';

  services.traefik-cloudflare.enable = true;
  services.traefik.dynamicConfigOptions = {
    http.routers = {
      nitter.rule = "Host(`twitter.${config.networking.domain}`)";
      nitter.service = "nitter";
    };

    http.services = {
      nitter.loadBalancer.servers = [{ url = "http://localhost:8083"; }];
    };
  };


  # services.nitter = {
  #   enable = true;
  #   preferences = {
  #     replaceTwitter = config.services.nitter.server.hostname;
  #     infiniteScroll = true;
  #     hlsPlayback = true;
  #     theme = "Auto";
  #   };
  #   server = {
  #     address = "127.0.0.1";
  #     https = true;
  #     hostname = "twitter.${config.networking.domain}";
  #     port = 8083;
  #   };
  # };


  system.activationScripts.makeInvidiousDir = lib.stringAfter [ "var" ] ''
    [ ! -d /var/lib/invidious ] && mkdir -p /var/lib/invidious-db
  '';

  virtualisation.podman.defaultNetwork.dnsname.enable = true;
  virtualisation.oci-containers.containers = {
    "nitter" = {
      image = "quay.io/unixfox/nitter";
      dependsOn = [ "nitter-redis" ];
      volumes = [
        "/var/lib/test/nitter.conf:/src/nitter.conf"
      ];
      extraOptions = [
        "--net=host"
        "--label"
        "traefik.enable=true"
        "--label"
        "traefik.http.routers.websecure-nitter.rule=Host(`twitter.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-nitter.entrypoints=websecure"
      ];
    };


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


}



podman run \
  --rm \
  --name='nitter' \
  --log-driver=journald \
  -v '/var/lib/test/nitter.conf:/src/nitter.conf' \
  quay.io/unixfox/nitter

