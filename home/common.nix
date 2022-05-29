{ pkgs, ... }: {

  imports = [
    ./git.nix
    ./zsh.nix
    ./ranger.nix
    ./nvim.nix
  ];

  home.packages = with pkgs;  [
    wget
    vim
    nix-tree
    tree
    htop
    neofetch
    unzip
    exa
  ];

}
