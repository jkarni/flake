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

    initExtraFirst = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  home.packages = with pkgs;  [
    zsh-powerlevel10k
  ];

}
