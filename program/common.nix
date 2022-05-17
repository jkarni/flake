{pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    wget
    vim
    ranger
    nix-tree
    tree
    htop
    neofetch
    unzip
    
    gcc
    ];
}
