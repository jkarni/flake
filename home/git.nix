{
  programs.git = {
    enable = true;
    userName = "mlyxshi";
    userEmail = "mlyxdev@gmail.com";
    ignores = [
      ".DS_Store" # macOS
    ];

    extraConfig = {
      init.defaultBranch = "main";
    };

  };
}
