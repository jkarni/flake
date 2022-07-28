{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  FirefoxProfilePath =
    if pkgs.stdenv.isLinux
    then ".mozilla/firefox"
    else "Library/Application Support/Firefox";

  NativeMessagingHostsPath =
    if pkgs.stdenv.isLinux
    then ".mozilla/native-messaging-hosts"
    else "Library/Application Support/Mozilla/NativeMessagingHosts";

  FirefoxPackage =
    if pkgs.stdenv.isLinux
    then pkgs.firefox-linux
    else pkgs.runCommand "firefox-0.0.0" { } "mkdir $out";

  ff-mpv = pkgs.writeScript "ff-mpv" ''
    #!${pkgs.python3}/bin/python

    import json
    import os
    import platform
    import struct
    import sys
    import subprocess


    def main():
        message = get_message()
        url = message.get("url")

        args = ["mpv", "--no-terminal", "--", url]

        kwargs = {}

        # HACK(ww): On macOS, graphical applications inherit their path from `launchd`
        # rather than the default path list in `/etc/paths`. `launchd` doesn't include
        # `/usr/local/bin` in its default list, which means that any installations
        # of MPV and/or youtube-dl under that prefix aren't visible when spawning
        # from, say, Firefox. The real fix is to modify `launchd.conf`, but that's
        # invasive and maybe not what users want in the general case.
        # Hence this nasty hack.
        if platform.system() == "Darwin":
            path = os.environ.get("PATH")
            # homebrew path
            os.environ["PATH"] = f"/opt/homebrew/bin:/usr/local/bin:{path}"


        subprocess.Popen(args, **kwargs)

        # Need to respond something to avoid "Error: An unexpected error occurred"
        # in Browser Console.
        send_message("ok")


    # https://developer.mozilla.org/en-US/Add-ons/WebExtensions/Native_messaging#App_side
    def get_message():
        raw_length = sys.stdin.buffer.read(4)
        if not raw_length:
            return {}
        length = struct.unpack("@I", raw_length)[0]
        message = sys.stdin.buffer.read(length).decode("utf-8")
        return json.loads(message)


    def send_message(message):
        content = json.dumps(message).encode("utf-8")
        length = struct.pack("@I", len(content))
        sys.stdout.buffer.write(length)
        sys.stdout.buffer.write(content)
        sys.stdout.buffer.flush()


    if __name__ == "__main__":
        main()
  '';
in {
  home.packages = [
    FirefoxPackage
  ];

  #  https://support.mozilla.org/en-US/kb/understanding-depth-profile-installation
  #  Linux firefox wrapper set MOZ_LEGACY_PROFILES=1 by default
  #  Under macOS, we need to set System-level environment variable MOZ_LEGACY_PROFILES=1 by launchctl setenv, See os/darwin/default.nix
  home.file = {
    "${FirefoxProfilePath}/profiles.ini".source = config.lib.file.mkOutOfStoreSymlink ../config/firefox/profile/profiles.ini;
    "${FirefoxProfilePath}/default/chrome".source = config.lib.file.mkOutOfStoreSymlink ../config/firefox/profile/default/chrome;

    # woodruffw/ff2mpv
    "${NativeMessagingHostsPath}/ff2mpv.json".text = ''
      {
        "name": "ff2mpv",
        "description": "ff2mpv's external manifest",
        "path": "${ff-mpv}",
        "type": "stdio",
        "allowed_extensions": ["ff2mpv@yossarian.net"]
      }
    '';
  };
}
