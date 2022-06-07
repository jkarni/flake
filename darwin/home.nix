{ pkgs, ... }: {

  imports = [
    ../home/common.nix
    ../home/mpv.nix
  ];

  home.packages = with pkgs;  [
    go
    ideviceinstaller
    rclone  
  ];

}
