# Must pass a variable to determine system, pkgs.stdenv.isLinux will cause infinite recursion
{
  pkgs,
  lib,
  ...
} @ args: {
  imports =
    [
      # common
      ./profile/developerMode.nix
      ./hm/stateVersion.nix
      ./hm/nixConfigDir.nix
    ]
    ++ lib.optionals (args ? isDarwin) [
      ./security/pam.nix
    ]
    ++ lib.optionals (args ? isLinux) [
      ./profile/desktopEnv.nix
      ./profile/waylandNightly.nix
      ./secrets
      ./services/shadowsocks-rust.nix
      ./services/ssh-config.nix
      ./services/qbittorrent-nox.nix
      ./services/rss-telegram.nix
      ./services/traefik-cloudflare.nix
    ];
}
