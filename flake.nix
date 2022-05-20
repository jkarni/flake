{

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    modes-nvim = {
      url = "github:mvllow/modes.nvim";
      flake = false;
    };

    nvim-lsp-installer = {
      url = "github:williamboman/nvim-lsp-installer";
      flake = false;
    };

  };

  outputs = { nixpkgs, home-manager, ... }@args: {

    nixosConfigurations."hx90-sway" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./host/hx90/module-sway.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.root = import ./host/hx90/home-sway.nix;
          home-manager.users.dominic = import ./host/hx90/home-sway.nix;
          home-manager.extraSpecialArgs = args;
        }
      ];
    };

    nixosConfigurations."hx90-gnome" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./host/hx90/module-gnome.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.root = import ./host/hx90/home-gnome.nix;
          home-manager.users.dominic = import ./host/hx90/home-gnome.nix;
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
