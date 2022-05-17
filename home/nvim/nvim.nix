{pkgs,...}:{

xdg.configFile."nvim"=./config;

programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
       tokyonight-nvim
       

    ];
   
    extraConfig = "lua require('init')";
};







}
