{ config, pkgs, developerMode, homeStateVersion, ... }: {

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit homeStateVersion developerMode; };
  home-manager.users.dominic = import ./home.nix;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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

  environment.systemPackages = with pkgs;[
    # See detail: overlay/Firefox-darwin.nix
    firefox
  ];

}
