{ pkgs, lib, config, neovim-nightly, ... }:
let
  cfg = config.profile.developerMode;
in
{
  options = {
    profile.developerMode.enable = lib.mkEnableOption "install extra dev package";
  };

  config = lib.mkIf cfg.enable {
    # nixpkgs.overlays = [
    #   (import ../../overlay/Nvim { inherit neovim-nightly; })
    # ];
  };
}
