{ pkgs, lib, ... }: {

  home.packages = with pkgs;  [
    lf
  ];

  home.activation.linklf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn $HOME/flake/config/lf  $HOME/.config/lf
  '';
}
