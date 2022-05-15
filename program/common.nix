{pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    tree
    htop
    neofetch
    ranger
    unzip
  ];
}
