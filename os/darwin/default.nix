{ pkgs
, lib
, config
, ...
}: {

  imports = [
    ./systemDefaults.nix
    ./launchd.nix
    ./activationScripts.nix
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      # interval is darwin launchd syntax
      interval = { Hour = 24; };
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

  sops.defaultSopsFile = ../../secrets/key.yaml;
  sops.age.keyFile = "/Users/dominic/Library/Application Support/sops/age/keys.txt";

  sops.secrets.restic-password = {
    owner = "dominic";
    group = "staff";
  };
}
