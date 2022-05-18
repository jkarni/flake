{ pkgs, ... }: {

  programs.zsh = {
    enable = true;

    shellAliases = {
      l = "ls -alh";
      v = "nvim";
      r = "ranger";
    };

    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "man"
      ];
    };


    sessionVariables = {
      EDITOR = "nvim";
    };




  };



}
