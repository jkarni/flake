{ pkgs, ... }: {

  programs.zsh = {
    enable = true;

    shellAliases = {
      l = "ls -al";
      v = "nvim";
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
