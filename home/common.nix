{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./git.nix
    ./zsh.nix
    ./ranger.nix
  ];

  xdg.configFile."nvim".source = ../config/nvim;

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
    ripgrep
    fd

    gcc #Tree-Sitter
    cargo
    nodejs
  ];

}
