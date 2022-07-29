{
  pkgs,
  lib,
  osConfig,
  ...
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
      mediainfo
      yt-dlp
      unzip
      rclone
      restic
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
      jq
      lazygit
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      neofetch
      ookla-speedtest
    ];

  home.stateVersion = osConfig.hm.stateVersion;
}
