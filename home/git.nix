{
  programs.git = {
    enable = true;
    userName = "mlyxshi";
    userEmail = "mlyxdev@gmail.com";

    delta.enable = true;
    
    ignores = [
      ".DS_Store" # macOS
    ];

    extraConfig = {
      init.defaultBranch = "main";
    };

  };
}
