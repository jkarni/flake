{ pkgs,config, ... }: {

  imports = [
    ../../home
    ../../home/kitty.nix
    ../../home/mpv.nix
    ../../home/firefox.nix
    ../../home/skhd.nix
  ];

  home.packages = with pkgs;  [
    gh
    go
    ideviceinstaller
    rclone
  ];
   
}

