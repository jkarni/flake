{ config, pkgs, lib, ... }:
let
  NitterConfig = pkgs.writeText "NitterConfig" ''
    [Server]
    address = "0.0.0.0"
    port = 9000
    https = false  # disable to enable cookies when not using https
    httpMaxConnections = 100
    staticDir = "./public"
    title = "nitter"
    hostname = "twitter.mlyxshi.com"
    [Cache]
    listMinutes = 240  # how long to cache list info (not the tweets, so keep it high)
    rssMinutes = 10  # how long to cache rss queries
    redisHost = "localhost"  # Change to "nitter-redis" if using docker-compose
    redisPort = 6379
    redisPassword = ""
    redisConnections = 20  # connection pool size
    redisMaxConnections = 30
    # max, new connections are opened when none are available, but if the pool size
    # goes above this, they're closed when released. don't worry about this unless
    # you receive tons of requests per second
    [Config]
    hmacKey = "secretkey"  # random key for cryptographic signing of video urls
    base64Media = false  # use base64 encoding for proxied media urls
    enableRSS = true  # set this to false to disable RSS feeds
    enableDebug = false  # enable request logs and debug endpoints
    proxy = ""  # http/https url, SOCKS proxies are not supported
    proxyAuth = ""
    tokenCount = 10
    # minimum amount of usable tokens. tokens are used to authorize API requests,
    # but they expire after ~1 hour, and have a limit of 187 requests.
    # the limit gets reset every 15 minutes, and the pool is filled up so there's
    # always at least $tokenCount usable tokens. again, only increase this if
    # you receive major bursts all the time
    # Change default preferences here, see src/prefs_impl.nim for a complete list
    [Preferences]
    theme = "Nitter"
    replaceTwitter = "nitter.net"
    replaceYouTube = "piped.kavin.rocks"
    replaceReddit = "teddit.net"
    replaceInstagram = ""
    proxyVideos = true
    hlsPlayback = false
    infiniteScroll = false
  '';
in
{


  virtualisation.oci-containers.containers = {
    # nitter and redis must be in the host network, I don't know why.
    "nitter" = {
      image = "quay.io/unixfox/nitter";
      dependsOn = [ "nitter-db" ];
      environment = {
        # "REPLACE_TWITTER" = "twitter.mlyxshi.com";
        REDIS_HOST="nitter-db";
      };

      volumes = [
        #"/var/lib/nitter/nitter.conf:/src/nitter.conf"
        "/var/lib/nitter:/data"  
      ];
      extraOptions = [
        "--no-healthcheck"
        
        "--label"
        "traefik.enable=true"
        "--label"
        "traefik.http.routers.websecure-nitter.rule=Host(`nitter.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-nitter.entrypoints=websecure"
      ];
    };

    "nitter-db" = {
      image = "redis";
      volumes = [
        "/var/lib/nitter-db:/data"
      ];
      cmd = [ "redis-server" "--save" "60" "1" "--loglevel" "warning" ];
      # extraOptions = [
      #   "--net=host"
      # ];
    };

  };


  # Fix Redis WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
  boot.kernel.sysctl = {
    "vm.overcommit_memory" = "1";
  };


  # cat ${NitterConfig} > /var/lib/nitter/nitter.conf
  systemd.services.podman-nitter.preStart = lib.mkAfter ''

    ${pkgs.cloudflare-dns-sync} nitter.${config.networking.domain}
  '';

  systemd.services.podman-nitter.serviceConfig.StateDirectory = "nitter";
  systemd.services.podman-nitter-db.serviceConfig.StateDirectory = "nitter-db";

}