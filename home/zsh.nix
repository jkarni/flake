{ pkgs, lib, config, ... }@args: {

  home.packages = with pkgs;  [
    zsh-fzf-tab
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
      
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      source ${args.zsh-autosuggestions}/zsh-autosuggestions.zsh 
      source ${args.zsh-fast-syntax-highlighting}/fast-syntax-highlighting.plugin.zsh
      source ${args.zsh-you-should-use}/you-should-use.plugin.zsh
      source ${args.zsh-tab-title}/zsh-tab-title.plugin.zsh    

    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''

      path+=~/go/bin
      path+=/Applications/Surge.app/Contents/Applications
    '';

  };

}
