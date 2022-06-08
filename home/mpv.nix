{ pkgs, lib,  ... }: {

  xdg.configFile = lib.optionalAttrs pkgs.stdenv.isLinux {
    "mpv".source = ../config/mpv;
  };

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkMPV = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/mpv  $HOME/.config/mpv
    '';
  };

  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
    # mpv is not optimized for MacOS, so I install mpv from homebrew in MacOS.
  ]++ lib.optional pkgs.stdenv.isLinux mpv;
}