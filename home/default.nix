{ pkgs, lib, homeStateVersion, osConfig,... }: {

  imports = [
    ./git.nix
    ./zsh.nix
    ./lf.nix
    ./nvim.nix
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
    # go
    pistol

  ] ++ lib.optionals osConfig.profile.developerMode.enable [
    jq
    statix
    lazygit
  ];


  home.stateVersion = homeStateVersion;
}