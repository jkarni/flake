{ pkgs, lib, ... }: {

  programs.firefox = {
    enable = true;
    # See details: overlay/Firefox.nix
    package =
      if pkgs.stdenv.isLinux
      then # Linux
        pkgs.firefox.overrideAttrs
          (old: {
            buildCommand = old.buildCommand + ''
              mkdir -p "$out/lib/$${libName}/defaults/pref"
              mkdir -p "$out/lib/$${libName}/TEST"
            '';
          })
      else # Darwin
        pkgs.firefox;
  };


  programs.firefox.profiles = {
    default = {
      id = 0;
    };
    developer = {
      id = 1;
    };
  };

  # nix-darwin only install application in "~/Application/Nix Apps" by default
  # I prefer also link to system application path

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn "${pkgs.firefox}/Applications/Firefox Nightly.app"  "/Applications/Firefox Nightly.app"

      ln -sfn  $HOME/flake/config/firefox/profile/chrome   "$HOME/Library/Application Support/Firefox/Profiles/default/chrome" 
    '';
  };


  home.file = lib.optionalAttrs pkgs.stdenv.isLinux {
    ".mozilla/firefox/default/chrome".source = ../config/firefox/profile/chrome;
  };

}
