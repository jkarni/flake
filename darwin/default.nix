{ config, pkgs, ... }: {

  imports = [
    ./brew.nix #For some packages in homebrew exclusively or Broken in nixpkgs
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # neovim binary cache
    binaryCaches = [
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # System Level ZSH Enable
  programs.zsh = {
    enable = true;
    variables = {
      EDITOR = "nvim";
    };
  };

  services.nix-daemon.enable = true;
}
