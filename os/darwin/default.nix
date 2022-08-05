{ pkgs
, lib
, config
, ...
}: {
  imports = [
    ./system.nix
    ./launchd.nix
    ./activationScripts.nix
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;

      # TODO: wait nix-darwin rename
      interval = { Hour = 24; } ;
      options = "--delete-older-than 7d";
    };
  };



  services.nix-daemon.enable = true;

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = true;

  # System Level ZSH Enable
  programs.zsh.enable = true;

  programs.ssh = {
    knownHosts = {
      github = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };
  };

  sops.defaultSopsFile = ../../modules/secrets/key.yaml;


  # Under Linux, use sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  # We do not allow openssh login under MacOS
  # This is using an age key that is expected to already be in the filesystem
  # ssh-to-age -private-key -i $HOME/.ssh/id_ed25519 -o "/Users/dominic/Library/Application Support/sops/age/keys.txt"
  sops.age.keyFile = "/Users/dominic/Library/Application Support/sops/age/keys.txt";


  sops.secrets.restic-password = {
    owner = "dominic";
    group = "staff";
  };
}
