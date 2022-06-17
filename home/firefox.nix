{ pkgs, lib, ... }: {

  programs.firefox = {
    enable = true;
    # See details: overlay/Firefox-linux.nix  overlay/Firefox-darwin.nix 
    package = pkgs.firefox;
  };


  programs.firefox.profiles = {
    default = {
      userChrome = builtins.readFile ../config/firefox/userChrome.css;
    };
  };

  # nix-darwin install application in "~/Application/Nix Apps" by default
  # link to system application in path
  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn ${pkgs.firefox}/Applications/Firefox.app /Applications/Firefox.app
    '';
  };

}
