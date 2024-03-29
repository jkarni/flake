local status, toggleterm = pcall(require, "toggleterm")
if not status then
  vim.notify("toggleterm Not Found")
  return
end


toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.3
    end
  end,
  open_mapping = require('keybindings').toggleTerm,
  insert_mappings = false, --Disable in insert mode
  direction = "horizontal",
})