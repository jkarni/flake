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

  
  # fonts={
  #   fontDir.enable =true;
  #   fonts = with pkgs;[
  #     (nerdfonts.override { fonts = [ "Hack" ]; })
  #   ];
  # };

  # System Level ZSH Enable
  programs.zsh={
    enable = true;
    variables = {
      EDITOR ="nvim";
    };
  };

  services.nix-daemon.enable = true;
}