{ pkgs,config, ... }: {

  imports = [
    ../../home
    ../../home/wezterm.nix
    ../../home/mpv.nix
    ../../home/firefox.nix
  ];

  home.packages = with pkgs;  [
    gh
    go
    ideviceinstaller
    rclone
  ];
   
}

