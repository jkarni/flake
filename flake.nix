{

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, home-manager, sops-nix, neovim-nightly, ... }@args: {

    nixosConfigurations."hx90" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./host/hx90/module.nix
        sops-nix.nixosModules.sops
        ./secrets
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.root = import ./host/hx90/home.nix;
          home-manager.users.dominic = import ./host/hx90/home.nix;
          nixpkgs.overlays = [
            neovim-nightly.overlay
          ];
          home-manager.extraSpecialArgs = args;
        }
      ];
    };


    nixosConfigurations."oracle" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./host/oracle/module.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.root = import ./host/oracle/home.nix;
          home-manager.extraSpecialArgs = args;
        }
      ];
    };

  };

}
