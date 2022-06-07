{ pkgs, ... }: {

  imports = [
    ../home/git.nix
    ../home/zsh.nix
    ../home/lf.nix
    ../home/mpv.nix
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
    procs
    bat
    delta
    unzip

    lazygit
    go
    ideviceinstaller
    rclone  


  ];

  home.stateVersion = "22.05";
}
