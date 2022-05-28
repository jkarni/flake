local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Format on Save
autocmd("BufWritePre", {
  callback = vim.lsp.buf.format,
  group = myAutoGroup,
  pattern = require("lang-config.treesitter.autoformat"),
})

--Packer
autocmd("BufWritePost", {
  group = myAutoGroup,
  pattern = "*.lua",
  callback = function()
    if vim.fn.expand("<afile>") == "lua/plugins.lua" then
      vim.api.nvim_command("source lua/plugins.lua")
      vim.api.nvim_command("PackerSync")
    end
  end,
})

--Treesitter
autocmd("BufWritePost", {
  group = myAutoGroup,
  pattern = "*.lua",
  callback = function()
    if vim.fn.expand("<afile>") == "lua/lang-config/treesitter/parsers.lua" then
      vim.api.nvim_command("source lua/lang-config/treesitter/parsers.lua")
      vim.api.nvim_command("TSUpdate")
    end
  end,
})

-- 用o换行不要延续注释
autocmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
        - "o" -- O and o, don't continue comments
        + "r" -- But do continue when pressing enter.
  end,
})
