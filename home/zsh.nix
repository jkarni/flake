{ pkgs, ... }: {

  home.packages = with pkgs;  [
    zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = ../config/.p10k.zsh;

  programs.zoxide.enable = true;

  programs.zsh = {
    
    enable = true;

    shellAliases = {
      l = "exa -algh";
      v = "nvim";
      r = "lf";
      p = "procs";
      g = "lazygit";
    };

    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    initExtraFirst = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';


  };

}