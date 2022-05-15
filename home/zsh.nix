{pkgs, ...}:{

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -al";
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
  };



}
