local status, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status then
  vim.notify("LSP Installer Not Found")
  return
end

-- lsp_installer.setup {
--   automatic_installation = true,
-- }

