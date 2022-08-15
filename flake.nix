# https://discourse.nixos.org/t/on-niv-running-on-mac-which-branch-should-i-use-to-update-to-21-11-i-cant-find-release-21-11-darwin-branch-on-nixpkgs/16446/7
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

    sops-nix-darwin = {
      url = "github:4825764518/sops-nix/darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:neovim/neovim";
      flake = false;
    };

  };

  outputs =
    { self
    , nixpkgs
    , darwin
    , home-manager
    , deploy-rs
    , sops-nix
    , sops-nix-darwin
    , ...
    } @ args:
    let
      stateVersion = "22.05";
      oracleServerList = [ "jp2" "jp4" "sw" "us1" "kr" "au" ];
      domain = "mlyxshi.com";
      commonSpecialArgs = {
        inherit (args) neovim-nightly;
      };
    in
    {
      #############################################################################################################################
      # darwinConfigurations

      darwinConfigurations = {
        "M1" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            sops-nix-darwin.nixosModules.sops
            home-manager.darwinModules.home-manager
            ./host/M1
            ./os/darwin/brew.nix
            ./overlay
            ./modules

            {
              networking.hostName = "M1";
              hm.stateVersion = stateVersion;
              hm.nixConfigDir = "/Users/dominic/flake";
              profile.developerMode.enable = true;
              security.pam.enableSudoTouchIdAuth = true; # https://github.com/LnL7/nix-darwin/pull/228
            }
          ];
          specialArgs = commonSpecialArgs;
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
            ./modules

            {
              networking.hostName = "hx90";
              system.stateVersion = stateVersion;
              hm.stateVersion = stateVersion;
              hm.nixConfigDir = "/etc/flake";
              profile.developerMode.enable = true;
            }
          ];
          specialArgs = commonSpecialArgs;
        };

        "test" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./host/test
            sops-nix.nixosModules.sops
            {
              system.stateVersion = stateVersion;
              networking.hostName = "test";
            }
          ];
        };
      }
      // nixpkgs.lib.genAttrs oracleServerList (hostName:
        nixpkgs.lib.nixosSystem {
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
              networking.hostName = hostName;
              networking.domain = domain;

              system.stateVersion = stateVersion;
              hm.stateVersion = stateVersion;
              hm.nixConfigDir = "/etc/flake";

              boot.loader.systemd-boot.netbootxyz.enable = true;
            }
          ];
          specialArgs = commonSpecialArgs;
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
          hostname = "${hostName}.${domain}";
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

      packages."aarch64-darwin"."Anime4k" = import ./pkgs/Anime4k { inherit (nixpkgs.legacyPackages."aarch64-darwin") stdenvNoCC unzip fetchurl; };

      packages."aarch64-linux"."ServerStatus" = import ./pkgs/ServerStatus { inherit (nixpkgs.legacyPackages."aarch64-linux") stdenv unzip fetchurl; };
      packages."aarch64-darwin"."ServerStatus" = import ./pkgs/ServerStatus { inherit (nixpkgs.legacyPackages."aarch64-darwin") stdenv unzip fetchurl; };
      #############################################################################################################################
      # Shell

      #  ${variable:-defaultValue}
      #  first unpackPhase is the string variable we defined
      #  second unpackPhase is the default unpackPhase function nixpkgs defined
      #  if we don't define unpackPhase, eval ${unpackPhase:-unpackPhase} -> eval unpackPhase   [eval function_name]
      #  if we define unpackPhase, eval ${unpackPhase:-unpackPhase} -> eval $unpackPhase   [eval shell_command_string_variable]

      # eval ${unpackPhase:-unpackPhase}
      # eval ${configurePhase:-configurePhase}
      # eval ${buildPhase:-buildPhase}
      # eval ${installPhase:-installPhase}   <-- Not working

      devShells."aarch64-darwin"."test" = import ./shells { pkgs = nixpkgs.legacyPackages."aarch64-darwin"; };
    }; #end of outputs
}
