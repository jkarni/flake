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

  services.libreddit = {
    enable = true;
    address = "127.0.0.1";
    port = 8082;
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


  sops.secrets.cloudflared-tunnel-us-env = { };
  systemd.services.cloudflared = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "systemd-resolved.service" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=$TOKEN"
      '';
      # Restart = "always";
      EnvironmentFile = config.sops.secrets.cloudflared-tunnel-us-env.path;
    };
  };


  virtualisation.oci-containers.containers = {

    "librespeed" = {
      image = "linuxserver/librespeed";
      volumes = [ "/var/lib/librespeed:/config" ];
      environment = {
        PASSWORD="PASSWORD";
      };
      extraOptions = [
        "--network=host"
      ];
    };
  };

}
