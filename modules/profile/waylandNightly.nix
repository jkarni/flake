{ pkgs
, lib
, config
, ...
}@args:
let
  cfg = config.profile.waylandNightly;
in
{
  options = {
    profile.waylandNightly.enable = lib.mkEnableOption "git version wayland desktop";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      args.nixpkgs-wayland.overlay
      (import ../../overlay/Mpv { inherit (args) mpv-nightly; })
    ];
  };
}
