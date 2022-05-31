{ config, ... }: {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  programs.ssh = {
    extraConfig = ''
      Host jp1
        HostName jp1.mlyxshi.com
        User root
        IdentityFile ${config.sops.secrets.ssh-private-key.path}

      Host github
        HostName github.com
        User git
        IdentityFile ${config.sops.secrets.ssh-private-key.path}
    '';
  };
}
    
