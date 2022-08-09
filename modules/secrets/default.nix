# common sops key
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
    # This will automatically import SSH keys as age keys
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    sops.secrets.shadowsocks-config = { };
    sops.secrets.ssh-private-key = { } // lib.optionalAttrs config.profile.desktopEnv.enable { owner = "dominic"; };
    sops.secrets.restic-password = { };
    sops.secrets.rclone-config = { };
    sops.secrets.traefik-cloudflare-env = { };
  };
}
