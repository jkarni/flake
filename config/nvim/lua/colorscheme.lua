local status, tokyonight = pcall(require, "tokyonight")
if not status then
  vim.notify("tokyonight Not Find")
  return
end

vim.api.nvim_command("colorscheme tokyonight")