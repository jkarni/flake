{
  PasswordManagerEnabled = false;
  DisableFirefoxStudies = true;
  DisablePocket = true;
  DisableTelemetry = true;

  # FirefoxAccount only for Sync bookmarks
  # DisableFirefoxAccounts = true;

  NoDefaultBookmarks = true;
  DontCheckDefaultBrowser = true;

  FirefoxHome = {
    Pocket = false;
    SponsoredTopSites = false;
  };

  # about:config
  # https://github.com/mozilla/policy-templates/#preferences
  Preferences = {
    #Force Dark theme 
    "browser.theme.toolbar-theme" = 0;
    "browser.theme.content-theme" = 0;

    "browser.aboutConfig.showWarning" = false;
    "browser.aboutwelcome.enabled" = false;

    "browser.startup.page" = 3; # Restore previous session

    "browser.toolbars.bookmarks.visibility" = "always";

    # Enable CustomCSS
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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

    # Dark Reader
    "addon@darkreader.org" = {
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
    };

    # Vimium
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
    };

    # DownThemAll
    "{DDC359D1-844A-42a7-9AA1-88A850A938A8}" = {
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/downthemall/latest.xpi";
    };
    
 

    # Uninstall Sponsored build-in Extension  <-- I only need google or duckduckgo
    # https://firefox-source-docs.mozilla.org/toolkit/mozapps/extensions/addon-manager/SystemAddons.html
    # about:support
    "ebay@search.mozilla.org" = {
      installation_mode = "blocked";
    };

    "amazondotcom@search.mozilla.org" = {
      installation_mode = "blocked";
    };

    "bing@search.mozilla.org" = {
      installation_mode = "blocked";
    };

  };

}
