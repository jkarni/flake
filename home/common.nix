{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./git.nix
    ./zsh.nix
    ./nvim/nvim.nix
  ];

  home.packages = with pkgs;  [
    wget
    vim
    ranger
    nix-tree
    tree
    htop
    neofetch
    unzip

  ];

}
