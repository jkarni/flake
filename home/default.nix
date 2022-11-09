{ pkgs
, lib
, osConfig
, ...
}: {
  imports = [
    ./git.nix
    ./zsh.nix
    ./lf.nix
    ./nvim.nix
  ];

  home.packages = with pkgs;
    [
      # basic
      wget
      file
      vim
      tree
      htop
      restic
      mediainfo
      yt-dlp
      unzip
      rclone
      ssh-to-age
      cloudflared
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
    ]
    ++ lib.optionals osConfig.profile.developerMode.enable [
      nixpkgs-fmt
      jq
      lazygit
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      neofetch
    ];

  home.stateVersion = osConfig.hm.stateVersion;
}
