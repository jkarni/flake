{ pkgs, lib, ... }: {

  # Rust autojump
  programs.zoxide.enable = true;

  #Rust prompt
  programs.starship.enable = true;

  home.file = lib.mkIf (pkgs.stdenv.system != "aarch64-darwin") {
    "starship.toml".source = ../config/starship.toml;
  };

  home.activation = lib.mkIf (pkgs.stdenv.system == "aarch64-darwin") {
    linkStarShip = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/starship.toml  $HOME/.config/starship.toml
    '';
  };

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
      path+=~/go/bin
      
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
