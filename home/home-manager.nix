{ ... }@args: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;

  home-manager.sharedModules = [
    ../modules/home
  ];

  home-manager.extraSpecialArgs = { inherit (args) homeStateVersion zsh-tab-title zsh-fast-syntax-highlighting zsh-you-should-use zsh-autosuggestions; };
}
