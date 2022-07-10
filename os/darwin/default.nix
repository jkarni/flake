{ pkgs
, lib
, config
, ...
}: {
  imports = [
    ./system.nix
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.nix-daemon.enable = true;

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = true;

  # System Level ZSH Enable
  programs.zsh.enable = true;

  programs.ssh = {
    knownHosts = {
      github = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };
  };

  # https://github.com/azuwis/nix-config/blob/master/darwin/skhd.nix
  # Add skhd to Settings->Privacy & Security->Accessibility        <-- launchd 
  system.activationScripts.postActivation.text = let path = "${pkgs.skhd}/bin/skhd"; in ''
    ${pkgs.sqlite}/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
      'INSERT or REPLACE INTO access VALUES("kTCCServiceAccessibility","${path}",1,2,4,1,NULL,NULL,0,NULL,NULL,0,NULL);
      DELETE from access where client_type = 1 and client != "${path}" and client like "%/bin/skhd";'
  '';


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
