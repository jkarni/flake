{ pkgs, lib, ... }: {

  home.packages = with pkgs;  [
    ranger
  ];

  home.activation.linkRanger = lib.hm.dag.entryAfter [ "writeBoundary" ]''
    ln -sfn $HOME/flake/config/ranger  $HOME/.config/ranger
  '';
}
