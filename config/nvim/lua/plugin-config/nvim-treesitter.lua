local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  vim.notify("nvim-treesitter Not Find")
  return
end


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
