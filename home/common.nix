{ pkgs, lib, homeStateVersion, config, ... }: {

  imports = [
    ./git.nix
    ./zsh.nix
    ./lf.nix
    ./nvim.nix
  ] ++ lib.optionals config.home.developerMode.enable [
    ./direnv.nix
  ];



  home.packages = with pkgs;  [
    # basic
    wget
    file
    vim
    tree
    htop
    neofetch
    unzip
    ookla-speedtest
    # nix
    nix-tree
    sops
    # rust
    exa
    delta
    tealdeer
    procs
    bandwhich
    bat
    bat-extras.batman

  ] ++ lib.optionals config.home.developerMode.enable [
    jq
    statix
    lazygit
  ];


  home.stateVersion = homeStateVersion;
}