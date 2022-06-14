{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
  ];

  services.samba.enable = true;
  services.samba.shares = {
    public =
      {
        path = "/srv/public";
        "read only" = true;
        browseable = "yes";
        "guest ok" = "yes";
        comment = "Public samba share.";
      };
    
    invalidUsers = lib.mkForce ["random"]; 
  };


}
