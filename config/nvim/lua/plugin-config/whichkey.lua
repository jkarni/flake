local status, whichkey = pcall(require, "which-key")
if not status then
  vim.notify("whichkey Not Found")
  return
end

whichkey.setup {}

