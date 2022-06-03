{ pkgs, ... }: {

  imports = [
    ../home/git.nix
    ./zsh.nix
    ./ranger.nix
    ./nvim.nix
  ];

  home.packages = with pkgs;  [
    neofetch
    nix-tree
    exa
    wget
    sops
    vim
    tree
    htop
    unzip

    rclone
    ideviceinstaller
  ];

  home.stateVersion = "22.05";
}
