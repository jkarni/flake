{ pkgs, ... }: {

  imports = [
    ../home/git.nix
    ./zsh.nix
    ./mpv.nix
    ./lf.nix
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
    delta
    unzip

    lazygit
    go
    ideviceinstaller
    rclone  


  ];

  home.stateVersion = "22.05";
}
