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

  ] ++ lib.optionals config.profile.developerMode.enable [ 
    jq
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
