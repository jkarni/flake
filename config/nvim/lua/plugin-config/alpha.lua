local status, alpha = pcall(require, "alpha")
if not status then
  vim.notify("alpha Not Found")
  return
end

local dashboard = require 'alpha.themes.dashboard'

dashboard.section.header.val = {
  [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
  [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
  [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
  [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
  [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
  [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  [[                                                   ]],
  [[                                                   ]],
}
dashboard.section.buttons.val = {
  dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
  dashboard.button("h", "  History files", ":Telescope oldfiles<CR>"),
  dashboard.button("e", "  Edit Projects ", ":edit ~/.local/share/nvim/project_nvim/project_history<CR>"),
}

dashboard.section.footer.val = "NixOS-Neovim"

alpha.setup(dashboard.config)
