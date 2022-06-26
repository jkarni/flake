{
  DisableAppUpdate = true;
  PasswordManagerEnabled = false;
  DisableFirefoxStudies = true;
  DisablePocket = true;
  DisableTelemetry = true;


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

    "browser.warnOnQuitShortcut" = false;

    # Enable CustomCSS
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;


  };


  # https://github.com/mozilla/policy-templates#extensionsettings
  ExtensionSettings = {
    # sync normal plugins by mozilla account 

    # customize the search shortcut

    # @ytb  -->  YouTube
    # @bili  -->  BiliBili
    # @gh  -->  GitHub
    # @nix  -->  Nix Package

    # all plugins are not signed 
    # use  https://github.com/xiaoxiaoflood/firefox-scripts to bypass the signature check


    "github@search" = {
      installation_mode = "force_installed";
      install_url = "https://github.com/mlyxshi/FireFox-Search-Shortcuts-Github/releases/download/v1.0/release.zip";
    };

    "youtube@search" = {
      installation_mode = "force_installed";
      install_url = "https://github.com/mlyxshi/FireFox-Search-Shortcuts-YouTube/releases/download/v1.0/release.zip";
    };

    "bilibili@search" = {
      installation_mode = "force_installed";
      install_url = "https://github.com/mlyxshi/FireFox-Search-Shortcuts-BiliBili/releases/download/v1.0/release.zip";
    };

    "nix.package@search" = {
      installation_mode = "force_installed";
      install_url = "https://github.com/mlyxshi/FireFox-Search-Shortcuts-Nix-Package/releases/download/v1.0/release.zip";
    };


    # Uninstall all build-in search shortcuts except google <-- my default search engine

    "ebay@search.mozilla.org" = {
      installation_mode = "blocked";
    };

    "amazondotcom@search.mozilla.org" = {
      installation_mode = "blocked";
    };

    "bing@search.mozilla.org" = {
      installation_mode = "blocked";
    };

    "ddg@search.mozilla.org" = {
      installation_mode = "blocked";
    };

    "wikipedia@search.mozilla.org" = {
      installation_mode = "blocked";
    };

  };

}
