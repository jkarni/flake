{ pkgs, lib, ... }: {

  programs.firefox = {
    enable = true;
    # See details: overlay/Firefox.nix
    package = pkgs.firefox;
  };


  programs.firefox.profiles = {
    default = {
      userChrome = builtins.readFile ../config/firefox/userChrome.css;
    };
  };

  # nix-darwin only install application in "~/Application/Nix Apps" by default
  # I prefer also link to system application path
  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn ${pkgs.firefox}/Applications/Firefox.app   /Applications/Firefox.app
    '';
  };

}
