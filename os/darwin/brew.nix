{pkgs, ...}: {
  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "uninstall";

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/services"
      "majd/repo"
      "koekeishiya/formulae" #yabai/skhd
      "xgadget-lab/nexttrace"
    ];

    brews = [
      "neofetch"
      "iproute2mac"
      "mas"
      "qemu"
      "mpv"
      "nexttrace"
      "imagemagick" #kitty image dependency
    ];

    # use launchd config from homebrew(original github config)
    # extraConfig = ''
    #   brew "skhd", restart_service: true
    # '';

    casks = [
      "kitty"
      "firefox"
      "macfuse" # rclone mount
      "utm"
      "font-roboto-mono-nerd-font"
      "calibre"
      "ipatool"
      "maczip"
      "openineditor-lite"
      "openinterminal-lite"
      "provisionql"
      "android-platform-tools"
      "nrlquaker-winbox"
      "wireshark"
      "raycast"
      "visual-studio-code"
      "qbittorrent"
      "google-drive"

      # Already installed from offical website <-- Uncomment this when completely reinstall macos
      # "surge"
      # "neteasemusic"

      # "google-chrome"

      # "tencent-lemon"
      # "airbuddy"
      # "bartender"
      # "deepl"
      # "imazing"
      # "checkra1n"
      # "uninstallpkg"
      # "suspicious-package"
      # "istat-menus"
      # "snipaste"
      # "paw"
    ];

    # Only for fresh installation
    # masApps = {
    #   # Safari Extension
    #   AdGuard = 1440147259;
    #   Userscripts = 1463298887;
    #   Octotree = 1457450145;
    #   uBlacklist = 1547912640;
    #   Tampermonkey = 1482490089;

    #   WeChat = 836500024;
    #   Telegram = 747648890;

    #   Things = 904280696;
    #   GoodNotes = 1444383602;
    #   PDF-Viewer = 1120099014;
    #   Cleaner-for-Xcode = 1296084683;
    #   Amphetamine = 937984704;
    #   Twilar = 1511758159;

    #   Rayon = 1609781496;
    #   Screens = 1224268771;
    #   Microsoft-Remote-Desktop = 1295203466;

    #   Paste = 967805235;
    #   Bob = 1630034110;
    #   Xcode = 497799835;
    #   Bitwarden = 1352778147;
    #   Infuse = 1136220934;
    #   LyricsX = 1254743014;
    #   Apple-Configurator = 1037126344;
    # };
  };
}
# Other Application not in Homebrew/Nixpkgs/Appstore
# Install Manually
# Hopper-Disassembler https://www.hopperapp.com/

