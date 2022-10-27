# http://technologeeks.com/docs/launchd.pdf
{ pkgs, config, ... }:
let
  skhdConfig = pkgs.writeText "skhdrc" ''
    ctrl - z : open -a "${pkgs.firefox-bin-darwin}/Applications/Firefox.app"
    ctrl - x : open -a "Visual Studio Code"
    alt - space : open -a "kitty"
  '';
in
{
  launchd.agents.FirefoxEnv = {
    serviceConfig.ProgramArguments = [
      "/bin/sh"
      "-c"
      "launchctl setenv MOZ_LEGACY_PROFILES 1; launchctl setenv MOZ_ALLOW_DOWNGRADE 1"
    ];
    serviceConfig.RunAtLoad = true;
  };

  launchd.agents.resticEnv = {
    serviceConfig.ProgramArguments = [
      "/bin/sh"
      "-c"
      "launchctl setenv RESTIC_REPOSITORY rclone:r2:backup; launchctl setenv RESTIC_PASSWORD_FILE ${config.sops.secrets.restic-password.path}"
    ];
    serviceConfig.RunAtLoad = true;
  };

  # skhd
  # Important, DO NOT USE services.skhd from nix-darwin
  # Details: 
  # https://github.com/azuwis/nix-config/commit/64a28173876aaf03f409691457e4f9500d868528
  # https://github.com/LnL7/nix-darwin/issues/406

  launchd.user.agents."SKHD" = {
    serviceConfig.ProgramArguments = [
      "/bin/sh"
      "-c"
      "/bin/wait4path /nix/store; /opt/homebrew/bin/skhd -c ${skhdConfig}"
    ];
    serviceConfig.RunAtLoad = true;
    serviceConfig.KeepAlive = true;
    # serviceConfig.EnvironmentVariables = {
    #   PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:/Users/dominic/.nix-profile/bin:/etc/profiles/per-user/dominic/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin";
    # };

    serviceConfig.StandardErrorPath = "/tmp/launchdLogs/skhd/error.log";
    serviceConfig.StandardOutPath = "/tmp/launchdLogs/skhd/stdout.log";
  };


  # https://unix.stackexchange.com/a/560404
  launchd.user.agents.SSH-ADD = {
    serviceConfig.ProgramArguments = [
      "/usr/bin/ssh-add"
      "/Users/dominic/.ssh/id_ed25519"
    ];
    serviceConfig.RunAtLoad = true;
  };
}
