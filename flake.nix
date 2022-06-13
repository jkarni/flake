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

    deploy-rs.url = "github:serokell/deploy-rs";

    sops-nix.url = "github:Mic92/sops-nix";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    nur.url = "github:nix-community/NUR";

  };

  outputs = { self, nixpkgs, darwin, home-manager, neovim-nightly, deploy-rs, sops-nix, nur, ... }@args: {

    darwinConfigurations = {

      "M1" = darwin.lib.darwinSystem {
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

    };


    nixosConfigurations = {

      "hx90" = nixpkgs.lib.nixosSystem {
        specialArgs = args;
        system = "x86_64-linux";
        modules = [
          nur.nixosModules.nur
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          ./host/hx90
          ./secrets

          {
            networking.hostName = "hx90";
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

    } // builtins.listToAttrs (

      builtins.map
        (hostName: {
          name = "${hostName}";
          value = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager
              ./host/oracle
              # https://nixos.wiki/wiki/Nix_Expression_Language
              # Coercing a relative path with interpolated variables to an absolute path (for imports)
              (./. + "/host/oracle/${hostName}.nix")
              ./secrets

              {
                networking.hostName = "${hostName}";
                nixpkgs.overlays = [
                  neovim-nightly.overlay
                ];
              }

            ];

          };
        }) [ "jp2" "jp4" "sw" "us1" "kr" ]

    ); # end of nixosConfigurations



    deploy = {
      sshUser = "root";
      user = "root";

      nodes = {
        "test" = {
          hostname = "sw.mlyxshi.com";
          profiles.system = {
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.sw;
          };
        };
      };
    };



  }; #end of outputs

}
