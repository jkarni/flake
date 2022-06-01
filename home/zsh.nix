{ pkgs, ... }: {

  programs.zsh = {
    enable = true;

    shellAliases = {
      l = "exa -algh";
      v = "nvim";
      r = "ranger";
    };

    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        # "git"
        # "man"
      ];
    };

  };



}
