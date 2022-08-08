{ config
, pkgs
, lib
, ...
}: {
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
      ${pkgs.cloudflare-dns-sync} reddit.mlyxshi.com
      ${pkgs.cloudflare-dns-sync} youtube.mlyxshi.com
      ${pkgs.cloudflare-dns-sync} twitter.mlyxshi.com
      ${pkgs.cloudflare-dns-sync} netease.mlyxshi.com
    fi
  '';

  services.traefik-cloudflare.enable = true;
  services.traefik.dynamicConfigOptions = {
    http.routers = {
      libreddit.rule = "Host(`reddit.mlyxshi.com`)";
      libreddit.service = "libreddit";

      nitter.rule = "Host(`twitter.mlyxshi.com`)";
      nitter.service = "nitter";

      youtube.rule = "Host(`youtube.mlyxshi.com`)";
      youtube.service = "youtube";
    };

    http.services = {
      libreddit.loadBalancer.servers = [{ url = "http://localhost:8082"; }];
      nitter.loadBalancer.servers = [{ url = "http://localhost:8083"; }];
      youtube.loadBalancer.servers = [{ url = "http://localhost:8084"; }];
    };
  };

  # services.libreddit = {
  #   enable = true;
  #   address = "127.0.0.1";
  #   port = 8082;
  # };

  virtualisation.oci-containers.containers = {
    "libreddit" = {
      image = "spikecodes/libreddit:arm";
      ports = [
        "8082:8080"
      ];
      environment = {
        WIDE = "on";
        SHOW_NSFW = "on";
        USE_HLS = "on";
      };
    };
  };

  services.nitter = {
    enable = true;
    preferences = {
      replaceTwitter = config.services.nitter.server.hostname;
      theme = "Auto";
    };
    server = {
      address = "127.0.0.1";
      https = true;
      hostname = "twitter.mlyxshi.com";
      port = 8083;
    };
  };

  services.invidious = {
    enable = true;
    domain = "youtube.mlyxshi.com";
    port = 8084;
  };

  # Do not use cloudflared, <--bandwidth limit

  # sops.secrets.cloudflared-tunnel-us-env = { };
  # systemd.services.cloudflared = {
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network-online.target" "systemd-resolved.service" ];
  #   serviceConfig = {
  #     ExecStart = ''
  #       ${pkgs.bash}/bin/bash -c "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=$TOKEN"
  #     '';
  #     # Restart = "always";
  #     EnvironmentFile = config.sops.secrets.cloudflared-tunnel-us-env.path;
  #   };
  # };


  # virtualisation.oci-containers.containers = {
  #   "librespeed" = {
  #     image = "linuxserver/librespeed";
  #     extraOptions = [
  #       "--network=host"
  #     ];
  #   };
  # };

}
