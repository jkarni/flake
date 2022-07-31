{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./default.nix
  ];


  virtualisation.oci-containers.containers = {
    # Port 9117
    "jackett" = {
      image = "linuxserver/jackett";
      volumes = [
        "/download/jackett/config:/config"
        "/download/jackett/downloads:/downloads"
      ];
      extraOptions = [
        "--network=host"
      ];
    };

  };
}
