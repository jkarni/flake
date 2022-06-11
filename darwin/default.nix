{ config, pkgs, ... }: {

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.dominic = import ./home.nix;

  imports = [
    ./brew.nix #For some packages in homebrew exclusively or Broken in nixpkgs
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    binaryCaches = [
      "https://mlyxshi.cachix.org"
    ];
    binaryCachePublicKeys = [
      "mlyxshi.cachix.org-1:yc7GPiryyBn0HfiCXdmO1ECWKBhfwrjdIFnRSA4ct7s="
    ];
  };

  services.nix-daemon.enable = true;

  nixpkgs.config.allowUnfree = true;

  # System Level ZSH Enable
  programs.zsh = {
    enable = true;
    variables = {
      EDITOR = "nvim";
      PAGER = "bat";
    };
  };

  programs.ssh = {
    knownHosts = {
      github = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };
  };

}
