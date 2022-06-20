{ pkgs, lib, config, ... }: {

  home.packages = with pkgs;  [
    zsh-fzf-tab
    zsh-fast-syntax-highlighting
    zsh-autosuggestions
    zsh-you-should-use
  ];

  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.starship.enable = true;
  programs.nix-index.enable = config.home.developerMode.enable;

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
    dotDir = ".config/zsh";

    history.path = "$HOME/.config/zsh/.zsh_history";

    shellAliases = {
      cd = "z";
      l = "exa -algh";
      v = "nvim";
      r = "lf";
      p = "procs";
      g = "lazygit";
      c = "bat";
      man = "batman";
      P = ''echo $PATH|sed "s/:/\n/g"'';
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      update = "cd ~/flake; git add .; darwin-rebuild switch --flake ~/flake#M1";
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      update = "cd /etc/flake; git pull; nixos-rebuild switch --flake /etc/flake#";
    };


    initExtra = '' 

      export FZF_COMPLETION_TRIGGER='\'

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh

      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

      function set_win_title() {
        echo -ne "\033]0; shell: $(basename "$PWD") \007"
      }
      precmd_functions+=(set_win_title)

    '' + lib.optionalString pkgs.stdenv.isDarwin ''
      path+=~/go/bin
      path+=/Applications/Surge.app/Contents/Applications
    '';

  };

}
