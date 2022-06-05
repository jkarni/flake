{ pkgs, ... }: {
  
  xdg.configFile."mpv".source = ../config/mpv;

  home.packages = with pkgs;  [
    mpv    
    ffmpeg
    yt-dlp
  ];
}