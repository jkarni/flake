{ pkgs, lib, config, osConfig, ... }: {

  home.packages =  [
    pkgs.kitty
  ];


  home.file.".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/kitty";

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkKitty = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn "${pkgs.kitty}/Applications/kitty.app"  "/Applications/kitty.app"
    '';
  };
}
