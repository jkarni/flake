{ ... }@args: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;

  home-manager.extraSpecialArgs = {
    osConfig = args.config;
    inherit (args) homeStateVersion;
    inherit (args) zsh-tab-title zsh-fast-syntax-highlighting zsh-you-should-use zsh-autosuggestions;
  };
}
