local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  vim.notify("nvim-treesitter Not Find")
  return
end

treesitter.setup({
  -- :TSInstallInfo 命令查看支持的语言
  -- Manually install latest tree-sitter if NixOS/pkgs have bug version
  ensure_installed = {"bash", "json", "typescript", "c","cpp","lua","nix" ,"rust","python" },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

})
