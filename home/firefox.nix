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
          "browser.theme.toolbar-theme" = 0;
          "browser.theme.content-theme" = 0;

          "browser.aboutConfig.showWarning" = false;
          "browser.aboutwelcome.enabled" = false;

          "browser.startup.page" = 3; # Restore previous session


          "media.ffmpeg.vaapi.enabled" = true;

          # Enable CustomCSS
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        };

        ManagedBookmarks = [
          {
            "toplevel_name" = "NixOS";
          }
          {
            "url" = "https://nixos.org/";
            "name" = "NixOS Website";
          }
          {
            "url" = "https://search.nixos.org/";
            "name" = "NixOS Search";
          }
          {
            "url" = "https://rycee.gitlab.io/home-manager/options.html";
            "name" = "Home Manager";
          }
          {
            "url" = "https://nixos.org/guides/nix-pills/";
            "name" = "Nix Pills";
          }
          {
            "url" = "https://nixos.org/manual/nix/unstable/expressions/builtins.html";
            "name" = "Nix Buildin Fn";
          }
          {
            "url" = "https://nixos.org/manual/nixpkgs/stable/";
            "name" = "NixPkgs Manual";
          }
          {
            "url" = "https://nixos.org/manual/nixos/stable/";
            "name" = "NixOS Manual";
          }
          {
            "url" = "https://github.com/mlyxshi/flake";
            "name" = "My Nix";
          }

        ];


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

    profiles.default = {
      # https://github.com/Aris-t2/CustomCSSforFx
      # Remove annoying "import bookmarks" button in PersonalToolbar 
      userChrome = "
        #import-button {
          display: none !important;
        }
      ";

    };

  };
}

