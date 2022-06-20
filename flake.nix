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

    zsh-tab-title = {
      url = "github:trystan2k/zsh-tab-title";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, darwin, home-manager, deploy-rs, neovim-nightly, sops-nix, zsh-tab-title, ... }:
    let
      stateVersion = "22.05";
      homeStateVersion = stateVersion;
      oracleServerList = [ "jp2" "jp4" "sw" "us1" "kr" ];
      commonsSpecialArgs = { inherit homeStateVersion neovim-nightly zsh-tab-title; };
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
            ./host/darwin
            ./host/darwin/brew.nix
            ./overlay
            ./overlay/Firefox-darwin.nix

          ];
          specialArgs = commonsSpecialArgs;
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
            ./overlay
            ./overlay/Firefox-linux.nix
            ./overlay/AppleFont.nix
            ./modules


            {
              system.stateVersion = stateVersion;
              networking.hostName = "hx90";

              profile.desktopEnv.enable = true;
              services.ssh-config.enable = true;
              secrets.sops-nix.enable = true;
            }
          ];
          specialArgs = commonsSpecialArgs;
        };

      } // nixpkgs.lib.genAttrs oracleServerList (hostName: nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          # https://nixos.wiki/wiki/Nix_Expression_Language
          # Coercing a relative path with interpolated variables to an absolute path (for imports)
          (./host/oracle + "/${hostName}.nix")
          ./overlay

          ./modules


          {
            system.stateVersion = stateVersion;
            networking.hostName = hostName;
            boot.loader.systemd-boot.netbootxyz.enable = true;

            secrets.sops-nix.enable = true;
            services.ssh-config.enable = true;
            services.shadowsocks-rust.enable = true;
          }
        ];
        specialArgs = commonsSpecialArgs;
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
      # Packages
      # nix build .#SF-Pro
      # cd test && nix develop ..#SF-Pro

      packages."x86_64-linux"."PingFang" = import ./pkgs/fonts/PingFang { inherit (nixpkgs.legacyPackages."x86_64-linux") stdenvNoCC unzip fetchurl; };
      packages."aarch64-darwin"."PingFang" = import ./pkgs/fonts/PingFang { inherit (nixpkgs.legacyPackages."aarch64-darwin") stdenvNoCC unzip fetchurl; };
      packages."x86_64-linux"."SF-Pro" = import ./pkgs/fonts/SF-Pro { inherit (nixpkgs.legacyPackages."x86_64-linux") stdenvNoCC unzip fetchurl; };
      packages."aarch64-darwin"."SF-Pro" = import ./pkgs/fonts/SF-Pro { inherit (nixpkgs.legacyPackages."aarch64-darwin") stdenvNoCC unzip fetchurl; };


      packages."aarch64-darwin"."firefox-darwin" = import ./pkgs/firefox-darwin { inherit (nixpkgs.legacyPackages."aarch64-darwin") stdenvNoCC lib fetchurl writeText undmg; };
      
      packages."aarch64-darwin"."zsh-tab-title" = import ./pkgs/zsh/zsh-tab-title.nix { inherit (nixpkgs.legacyPackages."aarch64-darwin") stdenvNoCC; inherit zsh-tab-title; };

      #############################################################################################################################
      # Shell
      # nix develop .#test 
      # eval ${unpackPhase:-unpackPhase}
      # eval ${configurePhase:-configurePhase}
      # eval ${buildPhase:-buildPhase}
      # eval ${installPhase:-installPhase}   <-- Not working

      devShells."aarch64-darwin"."test" = import ./shells { pkgs = nixpkgs.legacyPackages."aarch64-darwin"; };

    }; #end of outputs

}
