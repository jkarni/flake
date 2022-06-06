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
    procs
    lazygit
  ];

  home.stateVersion = "22.05";
}
