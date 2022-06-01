{ pkgs, ... }: {

  imports = [
    ./git.nix
    ./zsh.nix
    ./ranger.nix
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
  ];

  home.stateVersion = "22.05";
}
