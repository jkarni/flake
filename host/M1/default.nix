{

  imports = [
    ../../os/darwin
    ../../home/home-manager.nix
  ];


  home-manager.users.dominic = import ./home.nix;
  home-manager.sharedModules = [
    {
      home.developerMode.enable = true;
    }
  ];

}
