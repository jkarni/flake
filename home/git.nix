{
  programs.git = {
    enable = true;
    userName = "mlyxshi";
    userEmail = "mlyxdev@gmail.com";

    delta.enable = true;

    ignores = [
      ".DS_Store"
      ".vscode"
    ];

    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
