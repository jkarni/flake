local status, session = pcall(require, "auto-session")
if not status then
  vim.notify("session Not Found")
  return
end

session.setup {}
