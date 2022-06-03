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

  
  fonts={
    fontDir.enable =true;
    fonts = [pkgs.meslo-lgs-nf];
  };


  programs.zsh={
    enable = true;
  };

  services.nix-daemon.enable = true;
}