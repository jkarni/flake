{ pkgs, ... }: {

  imports = [
    ../home/common.nix
    ../home/wezterm.nix
    ../home/mpv.nix
    ../home/firefox.nix
    # ../modules/developerMode.nix
  ];

  # config.mode.developerMode = true;

  home.packages = with pkgs;  [
    gh
    go
    ideviceinstaller
    rclone
  ];

}

