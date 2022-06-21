{ pkgs, lib, osConfig, ... }@args: {

  home.packages = with pkgs;  [
    zsh-fzf-tab
  ];

  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.starship.enable = true;
  programs.nix-index.enable = osConfig.profile.developerMode.enable;

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


    initExtra = with args;'' 
      setopt globdots
      export FZF_COMPLETION_TRIGGER='\'

      source ${zsh-you-should-use}/you-should-use.plugin.zsh
      source ${zsh-tab-title}/zsh-tab-title.plugin.zsh   

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${zsh-autosuggestions}/zsh-autosuggestions.zsh 
      source ${zsh-fast-syntax-highlighting}/fast-syntax-highlighting.plugin.zsh



    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''

      path+=~/go/bin
      path+=/Applications/Surge.app/Contents/Applications
    '';

  };

}
