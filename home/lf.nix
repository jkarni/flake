{ pkgs, lib, ... }: {

  home.packages = with pkgs;  [
    lf
  ];

  xdg.configFile = lib.mkIf (pkgs.stdenv.system != "aarch64-darwin") {
    "lf".source = ../config/lf;
  };

  home.activation = lib.mkIf (pkgs.stdenv.system == "aarch64-darwin") {
    linklf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/lf  $HOME/.config/lf
    '';
  };
}
