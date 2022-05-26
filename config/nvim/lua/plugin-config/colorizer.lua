local status, colorizer = pcall(require, "colorizer")
if not status then
  vim.notify("colorizer Not Found")
  return
end

colorizer.setup()
