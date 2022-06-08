{ pkgs, ... }: {

  imports = [
    ./git.nix
    ./zsh.nix
    ./lf.nix
    ./nvim.nix
  ];

  home.packages = with pkgs;  [
    wget
    sops
    vim
    nix-tree
    tree
    htop
    neofetch
    unzip
    exa
    delta
    tldr
    procs
    bandwhich
    bat
    bat-extras.batman
    lazygit
  ];

  home.stateVersion = "22.05";
}
