{pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    wget
    vim
    neovim
    ranger
    clang
    #clang-tools
    # clangStdenv
    nix-tree
    tree
    htop
    neofetch
    unzip
  ];
}
