local status, telescope = pcall(require, "telescope")
if not status then
  vim.notify("Telescope Not Find")
  return
end
pcall(telescope.load_extension, "projects")
