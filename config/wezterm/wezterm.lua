local wezterm = require 'wezterm'

return {
  font = wezterm.font("RobotoMono Nerd Font"),
  font_size = 16,
  color_scheme = "wezterm_tokyonight_storm",

  window_close_confirmation = "NeverPrompt",
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,

  initial_cols = 140,
  initial_rows = 50,


  keys = {
    {key="w", mods="CMD", action=wezterm.action{CloseCurrentTab={confirm=false}}},
  },

}
