{pkgs, ...}:{
  launchd.agents.FirefoxEnv = {
    serviceConfig.ProgramArguments = [
      "bash"
      "-c"
      "launchctl setenv MOZ_LEGACY_PROFILES 1; launchctl setenv MOZ_ALLOW_DOWNGRADE 1"
    ];
    serviceConfig.RunAtLoad = true;
  };

  # skhd
  # Important, DO NOT USE services.skhd from nix-darwin
  # Details: https://github.com/azuwis/nix-config/commit/64a28173876aaf03f409691457e4f9500d868528
  launchd.user.agents.SKHD = {
    serviceConfig.ProgramArguments = [
      "${pkgs.skhd}/bin/skhd"
    ];
    serviceConfig.RunAtLoad = true;
    serviceConfig.KeepAlive = true;
    # serviceConfig.EnvironmentVariables = {
    #   PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:/Users/dominic/.nix-profile/bin:/etc/profiles/per-user/dominic/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin";
    # };

    serviceConfig.StandardErrorPath = "/tmp/launchdLogs/skhd/error.log";
    serviceConfig.StandardOutPath = "/tmp/launchdLogs/skhd/stdout.log";
  };

  # rclone mount googleshare:Download /Users/dominic/rcloneMount <-- mpv play anime
  launchd.user.agents.RcloneMount = {
    serviceConfig.ProgramArguments = [
      "${pkgs.rclone}/bin/rclone"
      "mount"
      "googleshare:Download"
      "/Users/dominic/rcloneMount"
    ];
    serviceConfig.RunAtLoad = true;
    serviceConfig.KeepAlive = true;

    serviceConfig.StandardErrorPath = "/tmp/launchdLogs/rclone-mount/error.log";
    serviceConfig.StandardOutPath = "/tmp/launchdLogs/rclone-mount/stdout.log";
  };

}