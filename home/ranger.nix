{ pkgs, lib, ... }: {

  # ranger conf-path must have write permission.
  # However xdg.configFile."<DIR>".source = DIR will create a unwritable dir in nixstore

  # We can utilize the activation scripts blocks to run when activating a Home Manager generation
  # Normally, we clone our flake repo under root. We need give all users permission to /etc/flake/config/ranger 

  home.packages = with pkgs;  [
    ranger
  ];

  home.activation.linkRanger = lib.hm.dag.entryAfter [ "writeBoundary" ]''
    if [ $(whoami) = root ]
    then
      chmod -R 777 /etc/flake/config/ranger
    fi

    ln -sfn /etc/flake/config/ranger  $HOME/.config/ranger
  '';
}
