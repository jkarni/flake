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


    nixosConfigurations."oracle-jp2" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        ./host/oracle
        ./host/oracle/jp2.nix
        ./secrets

        {
          nixpkgs.overlays = [
            neovim-nightly.overlay
          ];
        }
      ];
    };

    nixosConfigurations."oracle-jp4" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        ./host/oracle
        ./host/oracle/jp4.nix
        ./secrets

        {
          nixpkgs.overlays = [
            neovim-nightly.overlay
          ];
        }
      ];
    };

    nixosConfigurations."oracle-sw" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        ./host/oracle
        ./host/oracle/sw.nix
        ./secrets

        {
          nixpkgs.overlays = [
            neovim-nightly.overlay
          ];
        }
      ];
    };

    nixosConfigurations."oracle-kr" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        ./host/oracle
        ./host/oracle/kr.nix
        ./secrets

        {
          nixpkgs.overlays = [
            neovim-nightly.overlay
          ];
        }
      ];
    };

  };

}
