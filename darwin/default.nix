{ config, pkgs, ... }: {

  imports = [
    ./brew.nix #For some packages in homebrew exclusively or Broken in nixpkgs
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  # System Level ZSH Enable
  programs.zsh={
    enable = true;
    variables = {
      EDITOR ="nvim";
    };
  };

  services.nix-daemon.enable = true;
}