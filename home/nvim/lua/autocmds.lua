local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
	clear = true,
})

local autocmd = vim.api.nvim_create_autocmd


-- 保存时自动格式化
autocmd("BufWritePre", {
	group = myAutoGroup,
	pattern = { "*.lua", "*.py", "*.sh", "*.c", "*.cpp", "*.nix", "*.sh","*.json"},
	callback = vim.lsp.buf.formatting_sync,
})
