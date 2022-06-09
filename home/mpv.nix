# Use mpv as video player and image viewer
# mpv                                 <-- video(default)
# mpv --config-dir=$HOME/.config/mpi  <-- image
{ pkgs, lib, ... }: {

  xdg.configFile = lib.optionalAttrs pkgs.stdenv.isLinux {
    "mpv".source = ../config/mpv;
    "mpi".source = ../config/mpi;
  };

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkMPV = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/mpv  $HOME/.config/mpv
      ln -sfn $HOME/flake/config/mpi  $HOME/.config/mpi
    '';
  };

  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
    # mpv is not optimized for MacOS, so I install mpv from homebrew in MacOS.
  ] ++ lib.optionals pkgs.stdenv.isLinux [ mpv ];
}