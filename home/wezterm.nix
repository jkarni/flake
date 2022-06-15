{ pkgs, lib, ... }: {

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkWezterm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/wezterm  $HOME/.config/wezterm
    '';
  };

}
