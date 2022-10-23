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
  
  # https://github.com/nix-community/home-manager/blob/db00b39a9abec04245486a01b236b8d9734c9ad0/modules/targets/darwin/linkapps.nix
  home.file."Applications/Home Manager".source = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in "${apps}/Applications";
}
