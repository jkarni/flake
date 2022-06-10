{ pkgs, lib, ... }: {

  # Rust autojump
  programs.zoxide.enable = true;

  # Rust prompt
  programs.starship.enable = true;

  programs.nix-index.enable = true;

  home.file = lib.optionalAttrs pkgs.stdenv.isLinux {
    "starship.toml".source = ../config/starship.toml;
  };

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
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
      man = "batman";
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

    '' + lib.optionalString pkgs.stdenv.isDarwin ''
      path+=~/go/bin
      path+=/Applications/Surge.app/Contents/Applications
    '';

  };

}
