local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
  clear = true,
})

local autocmd = vim.api.nvim_create_autocmd


-- 保存时自动格式化
autocmd("BufWritePre", {
  group = myAutoGroup,
  pattern = { "*.lua", "*.nix", "*.sh", "*.py", "*.c", "*.cpp", "*.rs", "*.ts", "*.json" },
  callback = vim.lsp.buf.formatting_sync,
})
