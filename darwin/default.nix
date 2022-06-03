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

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];

  # This must be enable <-- darwin system level
  # Plus home manager zsh module  <-- user configuration level
  programs.zsh.enable = true;

  services.nix-daemon.enable = true;
}

