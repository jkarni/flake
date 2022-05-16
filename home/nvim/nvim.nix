{pkgs, ...}:{

xdg.configFile."nvim".source=./nvim;

programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
       tokyonight-nvim


    ];

};




}
