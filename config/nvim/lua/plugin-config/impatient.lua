local status, impatient = pcall(require, "impatient")
if not status then
  vim.notify("impatient Not Found")
  return
end

impatient.enable_profile()
