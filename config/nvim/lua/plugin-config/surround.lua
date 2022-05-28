local status, surround = pcall(require, "surround")
if not status then
  vim.notify('surround Not Found')
  return
end

surround.setup { mappings_style = "surround" }
