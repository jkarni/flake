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
    # @ghnix  -->  Nix Code in Github

    # plugins are self-signed
    # https://addons.mozilla.org/en-US/developers/

    "github@search" = {
      installation_mode = "force_installed";
      install_url = "https://raw.githubusercontent.com/mlyxshi/FFExtension/main/github-search.xpi";
    };

    "youtube@search" = {
      installation_mode = "force_installed";
      install_url = "https://raw.githubusercontent.com/mlyxshi/FFExtension/main/youtube-search.xpi";
    };

    "bilibili@search" = {
      installation_mode = "force_installed";
      install_url = "https://raw.githubusercontent.com/mlyxshi/FFExtension/main/bilibili-search.xpi";
    };

    "nix.package@search" = {
      installation_mode = "force_installed";
      install_url = "https://raw.githubusercontent.com/mlyxshi/FFExtension/main/nix-search.xpi";
    };

    "github.nix@search" = {
      installation_mode = "force_installed";
      install_url = "https://raw.githubusercontent.com/mlyxshi/FFExtension/main/github-nix.xpi";
    };

    # PT Plugin Plus
    "{530a53cf-3bc5-4f4f-9048-35a9459a89c9}" = {
      installation_mode = "force_installed";
      install_url = "https://raw.githubusercontent.com/mlyxshi/FFExtension/main/PT-Plugin-Plus-1.5.2.xpi";
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
