{ pkgs, ... }: {

  home.packages = with pkgs;  [
    zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = ../config/.p10k.zsh;

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

    dirHashes = if pkgs.stdenv.system == "aarch64-darwin" then { flake = "$HOME/flake"; } else { flake = "etc/flake"; };

    initExtra = if pkgs.stdenv.system == "aarch64-darwin" then ''
      path+=~/go/bin
      path+=/Applications/Surge.app/Contents/Applications
    '' else '' '';

  };

}