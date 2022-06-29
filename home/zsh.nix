{ pkgs, lib, osConfig, ... }@args:
let

  zsh-config = ../config/zsh;

in

{

  home.packages = with pkgs;  [
    fzf
    zsh-fzf-tab
  ];

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

    # under linux, use environment.sessionVariables to set env <-- headless mode and desktop mode
    # under darwin, use zsh module  <-- only desktop mode

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

    zstyle ':completion:*:descriptions' format '[%d]'
    zstyle ':fzf-tab:*' switch-group ',' '.'
  
    zstyle ':fzf-tab:complete:z:*' fzf-preview 'if [ -d "$realpath" ]; then exa -1 --color=always "$realpath"; else pistol "$realpath"; fi'
    zstyle ':fzf-tab:complete:z:*' fzf-pad 50

    zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
    zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:4:wrap'

    zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

    source ${zsh-you-should-use}/you-should-use.plugin.zsh
    source ${zsh-tab-title}/zsh-tab-title.plugin.zsh  

    source ${zsh-config}/fzf/completion.zsh
    source ${zsh-config}/fzf/key-bindings.zsh
    source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

    source ${zsh-autosuggestions}/zsh-autosuggestions.zsh 
    source ${zsh-fast-syntax-highlighting}/fast-syntax-highlighting.plugin.zsh

    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''
    
    export EDITOR=nvim
    export PAGER=bat

    path+=~/go/bin
    path+=/Applications/Surge.app/Contents/Applications
    '';

  };

}
