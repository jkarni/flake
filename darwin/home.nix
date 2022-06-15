{ pkgs, ... }: {

  imports = [
    ../home/common.nix
    ../home/wezterm.nix
    ../home/mpv.nix
  ];

  home.packages = with pkgs;  [
    gh
    go
    ideviceinstaller
    rclone
  ];

}

