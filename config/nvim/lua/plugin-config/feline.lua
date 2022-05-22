local status, feline = pcall(require, "feline")
if not status then
  vim.notify("feline Not Found")
  return
end

feline.setup()
