{ pkgs, lib, config, ... }: {
  sops.secrets.github-private-key = { };
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
        IdentityFile ${config.sops.secrets.github-private-key.path}
    '';
  };

}
