{ config, ... }: {
  # sshd (server)
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # ssh (client)
  programs.ssh = {

    knownHosts = {
      github = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };

    extraConfig = ''
      Host jp1
        HostName jp1.mlyxshi.com
        User root
        IdentityFile ${config.sops.secrets.ssh-private-key.path}

      Host github.com
        IdentityFile ${config.sops.secrets.ssh-private-key.path}
    '';
  };
}
