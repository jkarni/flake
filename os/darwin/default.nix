{ pkgs, ... }: {

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
      FZF_DEFAULT_COMMAND = "fd --type file --follow --hidden --exclude .git";
      FZF_CTRL_T_COMMAND = "fd --type file --follow --hidden --exclude .git";
      FZF_ALT_C_COMMAND = "fd --type file --follow --hidden --exclude .git";
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
