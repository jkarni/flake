local status, telescope = pcall(require, "telescope")
if not status then
  vim.notify("Telescope Not Find")
  return
end


local status, neoclip = pcall(require, "neoclip")
if not status then
  vim.notify("neoclip Not Find")
  return
end


neoclip.setup()

pcall(telescope.load_extension, "projects")
pcall(telescope.load_extension, "ui-select")
pcall(telescope.load_extension, "neoclip")
