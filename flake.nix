{
  inputs = {

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:neovim/neovim";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, darwin, home-manager, deploy-rs, neovim-nightly, sops-nix, ... }:
    let
      stateVersion = "22.05";
      homeStateVersion = stateVersion;
      oracleServerList = [ "jp2" "jp4" "sw" "us1" "kr" ];
    in
    {

      #############################################################################################################################
      # darwinConfigurations
      
      darwinConfigurations = {

        "M1" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            # sops-nix currently doesn't support aarch64-darwin
            home-manager.darwinModules.home-manager
            ./darwin
            ./darwin/brew.nix
            ./overlay/Neovim.nix
            ./overlay/Firefox-darwin.nix
          ];
          specialArgs = { inherit homeStateVersion neovim-nightly; };
        };

      };

      #############################################################################################################################
      # nixosConfigurations

      nixosConfigurations = {

        "hx90" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            ./host/hx90
            ./overlay/Neovim.nix
            ./overlay/Firefox-linux.nix
            ./overlay/AppleFont.nix

            {
              system.stateVersion = stateVersion;
              networking.hostName = "hx90";
            }
          ];
          specialArgs = { inherit homeStateVersion neovim-nightly; };
        };

      } // nixpkgs.lib.genAttrs oracleServerList (hostName: nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          # https://nixos.wiki/wiki/Nix_Expression_Language
          # Coercing a relative path with interpolated variables to an absolute path (for imports)
          (./host/oracle + "/${hostName}.nix")
          ./overlay/Neovim.nix

          {
            system.stateVersion = stateVersion;
            networking.hostName = hostName;
          }
        ];
        specialArgs = { inherit homeStateVersion neovim-nightly; };
      });


      #############################################################################################################################
      # deploy-rs

      deploy = {
        sshUser = "root";
        user = "root";
        sshOpts = [ "-o" "StrictHostKeyChecking=no" ];

        magicRollback = false;
        autoRollback = false;

        nodes = nixpkgs.lib.genAttrs oracleServerList (hostName: {
          hostname = "${hostName}.mlyxshi.com";
          profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.${hostName};
        });

      };
      #############################################################################################################################


    }; #end of outputs

}
