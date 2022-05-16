{pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    git
    wget
    tree
    htop
    neofetch
    nnn
    nvim
    unzip
  ];
}
