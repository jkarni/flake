{ ... } @ args: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;

  home-manager.extraSpecialArgs = {
    #inherit (args) zsh-tab-title;
  };
}
