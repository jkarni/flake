{pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    wget
    vim
    neovim
    ranger
    fd
    ripgrep 
    nix-tree
    tree
    htop
    neofetch
    unzip

		gcc
  ];
}
