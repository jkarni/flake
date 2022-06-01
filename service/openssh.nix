{ config, ... }: {
  # sshd (server)
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # ssh (client)
  programs.ssh = {
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
    
