{pkgs, ...}:{

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -al";
      vim = "nvim";
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

    
    sessionVariables={
       EDITOR="nvim";
       NNN_OPTS="eU";
       NNN_FIFO="/tmp/nnn.fifo";
    };




  };



}
