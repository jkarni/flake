{ pkgs, lib, ... }: {

  programs.firefox = {
    enable = true;
    # See details: overlay/Firefox.nix
    package = pkgs.firefox;
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

}
