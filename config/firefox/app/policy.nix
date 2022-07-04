{
  # https://github.com/mozilla/policy-templates/
  PasswordManagerEnabled = false;
  DisableTelemetry = true;
  DisableFirefoxStudies = true;
  DisablePocket = true;
  CaptivePortal = false;

  NoDefaultBookmarks = true;
  DontCheckDefaultBrowser = true;

  FirefoxHome = {
    Pocket = false;
    SponsoredTopSites = false;
  };

  # about:config
  # https://github.com/arkenfox/user.js/blob/master/user.js
  Preferences = {
    #Force Dark theme
    "browser.theme.toolbar-theme" = 0;
    "browser.theme.content-theme" = 0;

    "browser.startup.page" = 3; # Restore previous session
    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.toolbars.bookmarks.visibility" = "always";

    "browser.aboutConfig.showWarning" = false;
    "browser.aboutwelcome.enabled" = false;
    "browser.warnOnQuitShortcut" = false;
    "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;

    # disable recommended plugin on about:addons
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;

    # Enable CustomCSS
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };

  # https://github.com/mozilla/policy-templates#extensionsettings
  ExtensionSettings = {
    # sync normal plugins by mozilla account

    # customize the search shortcut, so I don't have to hack search.json.mozlz4  <-- write single search shortcut plugin is very simple

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
