local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
  clear = true,
})

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
  group = myAutoGroup,
  pattern = require("lang-config.treesitter.autoformat"),
  callback = vim.lsp.buf.formatting_sync,
})