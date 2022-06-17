{ pkgs, ... }: {

  programs.firefox = {

    enable = true;

    # See details: overlay/Firefox.nix 
    package = pkgs.firefox;

    profiles.default = {
      # https://github.com/Aris-t2/CustomCSSforFx
      # https://firefox-source-docs.mozilla.org/devtools-user/browser_toolbox/index.html
      # Remove annoying "import bookmarks" button in PersonalToolbar 
      userChrome = "
        #import-button, #fxa-toolbar-menu-button, #appMenu-passwords-button {
          display: none !important;
        }
      ";

    };

  };

}

