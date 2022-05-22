local status, fidget = pcall(require, "fidget")
if not status then
  vim.notify("fidget Not Found")
  return
end

fidget.setup{}