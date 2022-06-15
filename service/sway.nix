{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "sway";
        user = "dominic";
      };
      default_session = initial_session;
    };
  };

  environment.systemPackages = with pkgs; [
    kbct
  ];

  environment.etc = {
    "kbct/config.yml" = {
      text = ''
        - keyboards: [ 'Keychron Keychron K3' ]

          keymap:
            leftmeta: leftctrl
            rightctrl: leftmeta

          layers:
            - modifiers: ['leftmeta']
              keymap:
                c: copy
      '';
    };
  };

  systemd.services.kbct = {
    description = "kbct Daemon";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/kbct remap --config /etc/kbct/config.yml";
    };

  };

}