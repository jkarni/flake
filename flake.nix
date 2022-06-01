{
  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    neovim-nightly = {
      url = "github:neovim/neovim";
      flake = false;
    };

  };

  outputs = { nixpkgs, home-manager, sops-nix, neovim-nightly, ... }@args: {

    nixosConfigurations."hx90" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./host/hx90
        sops-nix.nixosModules.sops
        ./secrets
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.root = import ./home/sway-root.nix;
          home-manager.users.dominic = import ./home/sway-nonroot.nix;
          home-manager.extraSpecialArgs = args;
        }
      ];
    };


    nixosConfigurations."oracle" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./host/oracle
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.root = import ./home/server.nix;
          home-manager.extraSpecialArgs = args;
        }
      ];
    };

  };

}
