local status, whichkey = pcall(require, "which-key")
if not status then
  vim.notify("whichkey Not Found")
  return
end

whichkey.setup {
  plugins = {
    presets = {
      operators = false, -- disable help for operators like d, y, ... and registers them for motion / text object completion
    }
  }
}
