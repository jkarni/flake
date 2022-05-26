{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./git.nix
    ./zsh.nix
   # ./ranger.nix
    ./nvim.nix
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
