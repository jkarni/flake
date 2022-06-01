{ pkgs, ... }: {

  programs.firefox = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/blob/master/doc/builders/packages/firefox.section.md
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox/wrapper.nix
    # https://nixos.wiki/wiki/Firefox
    # https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#blob-path
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {

      forceWayland = true;

      # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
      extraPolicies = {

        PasswordManagerEnabled = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;

        FirefoxHome = {
          SponsoredTopSites = false;
          TopSites = false;
          Pocket = false;
        };

        NoDefaultBookmarks = true;
        DontCheckDefaultBrowser = true;

        # about:config
        # https://github.com/mozilla/policy-templates/#preferences
        Preferences = {
          # Dark theme 
          # "layout.css.prefers-color-scheme.content-override" = 0;
          "browser.theme.toolbar-theme" = 0;
          "browser.theme.content-theme" = 0;

          # Disable bookmarks in toolbar-theme
          # "browser.toolbars.bookmarks.visibility" = "never";
        };

        # https://github.com/mozilla/policy-templates#extensionsettings
        ExtensionSettings = {
          # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          };

          # Adguard
          "adguardadblocker@adguard.com" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguard-adblocker/latest.xpi";
          };


        };

      };

    };


  };
}
