local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  vim.notify("nvim-treesitter Not Find")
  return
end

--Very Strange Fix! https://github.com/nvim-treesitter/nvim-treesitter/issues/1449
--But it just works in Both MacOS and NixOS!
-- The root issue of clang in NixOS:
--https://github.com/nvim-treesitter/nvim-treesitter/issues/1449#issuecomment-870482532

require 'nvim-treesitter.install'.compilers = { 'clang++' }

treesitter.setup({

  ensure_installed = require("lang-config.treesitter.parsers"),

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

})

