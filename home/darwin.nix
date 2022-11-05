{ pkgs
, config
, osConfig
, ...
}: {
  imports = [
    ./default.nix
    ./kitty.nix
    ./mpv.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    gh
    go
    ideviceinstaller
  ];

}
