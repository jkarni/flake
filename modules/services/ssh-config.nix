{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.ssh-config;
in
{
  options = {
    services.ssh-config.enable = lib.mkEnableOption "my ssh service";
  };

  config = lib.mkIf (cfg.enable && config.secrets.sops-nix.enable) {
    # ssh (client)
    programs.ssh = {
      knownHosts = {
        github = {
          hostNames = [ "github.com" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        };
      };

      extraConfig = ''
        Host github.com
          User git
          IdentityFile ${config.sops.secrets.ssh-private-key.path}
      '';
    };
  };
}
