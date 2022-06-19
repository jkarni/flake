{ pkgs, lib, homeStateVersion, config, ... }: {

  imports = [
    ./git.nix
    ./zsh.nix
    ./lf.nix
    ./nvim.nix
  ];

            
            
  home.packages = with pkgs;  [
    # basic
    wget
    jq
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

  ] ++ lib.optionals config.mode.developerMode.enable [ 
    statix 
    lazygit
  ];

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv = {
  #     enable = true;
  #   };
  # };

  home.stateVersion = homeStateVersion;
}
