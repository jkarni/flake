# Use mpv as video player and image viewer
# mpv                                 <-- video(default)
# mpv --config-dir=$HOME/.config/mpi  <-- image
{ pkgs, lib, ... }:
let
  anime4k = pkgs.Anime4k;
  Anime4kInputs = {
    #lower-end GPU    <-- Apple M1 
    "CTRL+1" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A (Fast)"'';
    "CTRL+2" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B (Fast)"'';
    "CTRL+3" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C (Fast)"'';
    "CTRL+4" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_Restore_CNN_S.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A+A (Fast)"'';
    "CTRL+5" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Restore_CNN_Soft_S.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B+B (Fast)"'';
    "CTRL+6" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Restore_CNN_S.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C+A (Fast)"'';
    "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
  };
in

{

  programs.mpv = {
    enable = true;
    # Install mpv from Homebrew, nixpkgs doesn't optimize for Darwin
    # This populates a dummy package to satsify the requirement
    package =
      if pkgs.stdenv.isLinux
      then # Linux
        pkgs.mpv
      else # Darwin
        pkgs.runCommand "mpv-0.0.0" { } "mkdir $out";

    bindings = {
      # https://github.com/mpv-player/mpv/blob/master/etc/input.conf
      h = "add sub-pos -1";
      H = "add sub-pos +1";
    } // Anime4kInputs;

  };

  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
  ];

  #############################################################################
  # MPV

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkMPV = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/mpv/mpv.conf  $HOME/.config/mpv/mpv.conf 
      ln -sfn $HOME/flake/config/mpv/scripts $HOME/.config/mpv/scripts
      ln -sfn $HOME/flake/config/mpv/script-opts   $HOME/.config/mpv/script-opts  
    '';
    linkMPI = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/mpi  $HOME/.config/mpi
    '';
  };

  xdg.configFile = lib.optionalAttrs pkgs.stdenv.isLinux {
    "mpv/mpv.conf".source = ../config/mpv/mpv.conf;
    "mpv/scripts".source = ../config/mpv/scripts;
    "mpv/script-opts".source = ../config/mpv/script-opts;

    "mpi".source = ../config/mpi;
  };


}
