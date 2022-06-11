{
  inputs = {

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    nur.url = "github:nix-community/NUR";

  };

  outputs = { nixpkgs, darwin, home-manager, neovim-nightly, sops-nix, nur, ... }@args: {

    darwinConfigurations."M1" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        # sops-nix currently doesn't support aarch64-darwin
        home-manager.darwinModules.home-manager
        ./darwin
        ./darwin/brew.nix

        {
          nixpkgs.overlays = [
            neovim-nightly.overlay
          ];
        }
      ];
    };

    nixosConfigurations."hx90" = nixpkgs.lib.nixosSystem {
      specialArgs = args;
      system = "x86_64-linux";
      modules = [
        nur.nixosModules.nur
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        ./host/hx90
        ./secrets

        {
          nixpkgs.overlays = [
            neovim-nightly.overlay
            (final: prev: {
              PingFang = prev.callPackage ./pkgs/fonts/PingFang { };
              SF-Pro = prev.callPackage ./pkgs/fonts/SF-Pro { };
            })
          ];
        }

      ];
    };


    nixosConfigurations."oracle" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        ./host/oracle
        ./secrets

        {
          nixpkgs.overlays = [
            neovim-nightly.overlay
          ];
        }
      ];
    };

  };

  darwinConfigurations."M1-Non-Homebrew" = darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      home-manager.darwinModules.home-manager
      ./darwin

      {
        nixpkgs.overlays = [
          neovim-nightly.overlay
        ];
      }
    ];
  };

}
