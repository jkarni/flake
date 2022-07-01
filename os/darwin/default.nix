{ pkgs, ... }: {

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



  #  launchd related folder: /var/db/com.apple.xpc.launchd
  #  sudo launchctl bootstrap  system  /Library/LaunchAgents/org.nixos.FirefoxEnv.plist
  #  sudo launchctl enable system/org.nixos.FirefoxEnv
  launchd.agents.FirefoxEnv = {
    serviceConfig.ProgramArguments = [
      "bash"
      "-c"
      "launchctl setenv MOZ_LEGACY_PROFILES 1; launchctl setenv MOZ_ALLOW_DOWNGRADE 1"
    ];
    serviceConfig.RunAtLoad = true;
  };

}
