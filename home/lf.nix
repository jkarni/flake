{ pkgs, lib, ... }: {

  home.packages = with pkgs;  [
    lf
  ];

  xdg.configFile = lib.optionalAttrs pkgs.stdenv.isLinux {
    "lf".source = ../config/lf;
  };

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linklf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/lf  $HOME/.config/lf
    '';
  };
}
