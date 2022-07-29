{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.unblock-netease-music.enable = true;

  sops.secrets.tg-userid = { };
  sops.secrets.tg-rss-token = { };

  virtualisation.oci-containers.containers = {

    "rss-telegram" = {
      image = "rongronggg9/rss-to-telegram";
      volumes = [ "/etc/rss/:/app/config" ];
      environment = {
        TOKEN = builtins.readFile "${config.sops.secrets.tg-rss-token.path}"; # get it from @BotFather
        MANAGER = builtins.readFile "${config.sops.secrets.tg-userid.path}"; # get it from @userinfobot
      };
    };


  };
}
