{ pkgs, lib,  ... }: {

  xdg.configFile = lib.mkIf (pkgs.stdenv.system != "aarch64-darwin") {
    "mpv".source = ../config/mpv;
  };

  home.activation = lib.mkIf (pkgs.stdenv.system == "aarch64-darwin") {
    linkMPV = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/mpv  $HOME/.config/mpv
    '';
  };

  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
    # mpv is not optimized for MacOS, so I install mpv from homebrew in MacOS.
  ]++ lib.optional (pkgs.stdenv.system != "aarch64-darwin") mpv;
}