{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.secrets.sops-nix;
in
{
  options = {
    secrets.sops-nix.enable = lib.mkEnableOption "sops secret service";
  };

  config = lib.mkIf cfg.enable {
    sops.defaultSopsFile = ./key.yaml;
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    sops.secrets.tg-chatid = { };
    sops.secrets.tg-token = { };
    sops.secrets.shadowsocks-config = { };
    sops.secrets.ssh-private-key = { } // lib.optionalAttrs config.profile.desktopEnv.enable { owner = "dominic"; };
  };
}
