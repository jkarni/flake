{pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    wget
    vim
    tree
    htop
    neofetch
    unzip
  ];
}
