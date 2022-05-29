local status, _ = pcall(require, "tokyonight")
if not status then
  vim.notify("tokyonight Not Find")
  return
end

vim.cmd("colorscheme tokyonight")
