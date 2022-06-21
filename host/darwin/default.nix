{ pkgs, ... }@args: {

  imports =[
    ../../home/home-manager.nix
  ];


  home-manager.users.dominic = import ./home.nix;
  home-manager.sharedModules = [
    {
      home.developerMode.enable = true;
    }
  ];

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
      FZF_COMPLETION_TRIGGER="\\\\";  # actual value is '\' , but nix-lang and shell need escape  <-- weird
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
