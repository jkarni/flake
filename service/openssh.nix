{ config, lib, ... }: {

  # sshd (server)
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe" ];
  } // lib.optionalAttrs (config.users.users ? dominic) { dominic.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe" ]; };



  # ssh (client)
  programs.ssh = {

    knownHosts = {
      github = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };

    extraConfig = ''
      Host jp1.mlyxshi.com
        User root
        IdentityFile ${config.sops.secrets.ssh-private-key.path}

      Host github.com
        User git
        IdentityFile ${config.sops.secrets.ssh-private-key.path}
    '';
  };
}
