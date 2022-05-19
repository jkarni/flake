local status, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status then
  vim.notify("LSP Installer Not Found")
  return
end

--local function get_keys(t)
--  local keys = {}
--  for key, _ in pairs(t) do
--    table.insert(keys, key)
--  end
--  return keys
--end

lsp_installer.setup {
  -- ensure_installed = get_keys(require("lsp/servers"))

  -- Fix NixPKG Bug LSP servers
  ensure_installed = { "tsserver", "jsonls" }
}
