{pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    wget
    vim
    neovim
    ranger
    clang
    fd
    ripgrep 
    #clang-tools
    #clangStdenv
    nix-tree
    tree
    htop
    neofetch
    unzip
  ];
}
