{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.unblock-netease-music.enable = true;

  sops.secrets.tg-userid = { };
  sops.secrets.tg-rss-token = { };

  system.activationScripts.makeRssConfigDir = stringAfter [ "var" ] ''
    mkdir -p /var/lib/rss
  '';


  system.activationScripts.generateSecretEnv = lib.stringAfter [ "var" ] ''
    echo MANAGER=$(cat ${config.sops.secrets.tg-userid.path}) > /tmp/rss-telegram.env
    echo TOKEN=$(cat ${config.sops.secrets.tg-rss-token.path}) >> /tmp/rss-telegram.env
  '';


  virtualisation.oci-containers.containers = {

    "rss-telegram" = {
      image = "rongronggg9/rss-to-telegram";
      volumes = [ "/var/lib/rss:/app/config" ];

      environmentFiles = [
        /tmp/rss-telegram.env
      ];
    };


  };
}
