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
    neovim
    ranger
    nix-tree
    tree
    htop
    neofetch
    unzip
  ];

}
