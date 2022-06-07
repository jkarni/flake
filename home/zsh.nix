{ pkgs, lib, ... }: {

  # Rust autojump
  programs.zoxide.enable = true;

  #Rust prompt
  programs.starship.enable = true;

  home.file."starship.toml".source = ../config/starship.toml;

  programs.zsh = {

    enable = true;

    shellAliases = {
      l = "exa -algh";
      v = "nvim";
      r = "lf";
      p = "procs";
      g = "lazygit";
      c = "bat";
    };

    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;


    initExtra = ''
      
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