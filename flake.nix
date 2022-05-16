{

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: {

    nixosConfigurations."hx90" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/hx90.nix
        ./configuration/hx90.nix
        ./program/desktop.nix
        ./service/desktop.nix
        home-manager.nixosModules.home-manager{
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dominic = import ./home/common.nix;
            home-manager.users.root = import ./home/common.nix;
        }
      ];
    };

    nixosConfigurations."oracle" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./hardware/oracle.nix
        ./configuration/oracle.nix
        ./program/server.nix
        ./service/server.nix
        home-manager.nixosModules.home-manager{
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.root = import ./home/common.nix;
        }
      ];
    };




  };


}
