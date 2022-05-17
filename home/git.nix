{ pkgs, ... }: {


  programs.git = {
    enable = true;
    userName = "mlyxshi";
    userEmail = "mlyxdev@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
    };


  };


}
