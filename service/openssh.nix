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
        Port 22
        IdentityFile ${config.sops.secrets.ssh-private-key.path}
    '';
  };
}
    
