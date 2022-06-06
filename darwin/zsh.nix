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

    dirHashes =  { flake = "$HOME/flake"; };

    initExtra = ''
      path+=~/go/bin
      path+=/Applications/Surge.app/Contents/Applications  # surge-cli
      
      lfcd () {
        tmp="$(mktemp)"
        lf -last-dir-path="$tmp" "$@"
        if [ -f "$tmp" ]; then
          dir="$(cat "$tmp")"
          rm -f "$tmp"
          if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
              cd "$dir"
            fi
          fi
        fi
      }

      bindkey -s '^f' 'lfcd\n'  # zsh
    '';

  };

}