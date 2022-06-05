{ pkgs, lib, youtube-dl-nightly, ... }: {
  home.activation.linkMPV = lib.hm.dag.entryAfter [ "writeBoundary" ]''
    ln -sfn $HOME/flake/config/mpv  $HOME/.config/mpv
  '';

  home.packages = with pkgs;  [
    # mpv    Don't use mpv from nixpkgs <-- Not optimized for macos
    ffmpeg
    yt-dlp
  ];
}
