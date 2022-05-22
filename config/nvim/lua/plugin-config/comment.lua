local status, comment = pcall(require, "Comment")
if not status then
  vim.notify("Comment Not Found")
  return
end

comment.setup()
