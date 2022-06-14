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

  outputs = { self, nixpkgs, darwin, home-manager, deploy-rs, neovim-nightly, sops-nix, ... }@args:
    let
      stateVersion = "22.05";
      
      neovimOverlay = (final: prev: {
        neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
          version = "master";
          src = neovim-nightly;
        });
      });

      AppleFontOverlay = (final: prev: {
        PingFang = prev.callPackage ./pkgs/fonts/PingFang { };
        SF-Pro = prev.callPackage ./pkgs/fonts/SF-Pro { };
      });
    in
    {

      darwinConfigurations = {

        "M1" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            # sops-nix currently doesn't support aarch64-darwin
            home-manager.darwinModules.home-manager
            ./darwin
            ./darwin/brew.nix
            { nixpkgs.overlays = [ neovimOverlay ]; }
          ];
        };

      };


      nixosConfigurations = {

        "hx90" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            ./host/hx90

            { 
              system.stateVersion = stateVersion;
              home.stateVersion = stateVersion;
              networking.hostName = "hx90";
              nixpkgs.overlays = [ neovimOverlay AppleFontOverlay];
            }
          ];
        };

      } // builtins.listToAttrs (

        builtins.map
          (hostName: {
            name = hostName;
            value = nixpkgs.lib.nixosSystem {
              system = "aarch64-linux";
              modules = [
                sops-nix.nixosModules.sops
                home-manager.nixosModules.home-manager
                # https://nixos.wiki/wiki/Nix_Expression_Language
                # Coercing a relative path with interpolated variables to an absolute path (for imports)
                (./host/oracle + "/${hostName}.nix")

                {
                  system.stateVersion = stateVersion;
                  home.stateVersion = stateVersion;
                  networking.hostName = hostName;
                  nixpkgs.overlays = [ neovimOverlay ];
                }
              ];
            };
          }) [ "jp2" "jp4" "sw" "us1" "kr" ]

      ); # end of nixosConfigurations



      deploy = {
        sshUser = "root";
        user = "root";
        sshOpts = [ "-o" "StrictHostKeyChecking=no" ];

        magicRollback = false;
        autoRollback = false;

        nodes = builtins.listToAttrs (
          builtins.map
            (hostName: {
              name = hostName;
              value = {
                hostname = "${hostName}.mlyxshi.com";
                profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.${hostName};
              };

            }) [ "jp2" "jp4" "kr" "us1" "sw" ]
        );

      }; # end of deploy



    }; #end of outputs

}
