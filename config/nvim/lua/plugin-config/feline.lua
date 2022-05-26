local status, feline = pcall(require, "feline")
if not status then
  vim.notify("feline Not Found")
  return
end

local lsp = require('feline.providers.lsp')

--https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/colors.lua
local colors = {
  none = "NONE",
  bg_dark = "#1f2335",
  bg = "#24283b",
  bg_highlight = "#292e42",
  terminal_black = "#414868",
  fg = "#c0caf5",
  fg_dark = "#a9b1d6",
  fg_gutter = "#3b4261",
  dark3 = "#545c7e",
  comment = "#565f89",
  dark5 = "#737aa2",
  blue0 = "#3d59a1",
  blue = "#7aa2f7",
  cyan = "#7dcfff",
  blue1 = "#2ac3de",
  blue2 = "#0db9d7",
  blue5 = "#89ddff",
  blue6 = "#B4F9F8",
  blue7 = "#394b70",
  magenta = "#bb9af7",
  magenta2 = "#ff007c",
  purple = "#9d7cd8",
  orange = "#ff9e64",
  yellow = "#e0af68",
  green = "#9ece6a",
  green1 = "#73daca",
  green2 = "#41a6b5",
  teal = "#1abc9c",
  red = "#f7768e",
  red1 = "#db4b4b",
  white = "#FFFFFF"
}

-- https://github.com/feline-nvim/feline.nvim/blob/master/USAGE.md

local vi_mode = {
  ['n'] = { mode = 'NORMAL', color = colors.blue },
  ['niI'] = { mode = 'NORMAL', color = colors.blue },
  ['niR'] = { mode = 'NORMAL', color = colors.blue },
  ['niV'] = { mode = 'NORMAL', color = colors.blue },
  ['v'] = { mode = 'VISUAL', color = colors.purple },
  ['V'] = { mode = 'V-LINES', color = colors.purple },
  [''] = { mode = 'V-BLOCK', color = colors.purple },
  ['s'] = { mode = 'SELECT', color = colors.white },
  ['S'] = { mode = 'SELECT', color = colors.white },
  [''] = { mode = 'BLOCK', color = colors.purple },
  ['i'] = { mode = 'INSERT', color = colors.teal },
  ['ic'] = { mode = 'INSERT', color = colors.teal },
  ['ix'] = { mode = 'INSERT', color = colors.teal },
  ['R'] = { mode = 'REPLACE', color = colors.red },
  ['Rc'] = { mode = 'REPLACE', color = colors.red },
  ['Rx'] = { mode = 'REPLACE', color = colors.red },
  ['Rv'] = { mode = 'V-REPLACE', color = colors.red },
  ['c'] = { mode = 'COMMAND', color = colors.yellow },
  ['cv'] = { mode = 'COMMAND', color = colors.yellow },
  ['ce'] = { mode = 'COMMAND', color = colors.yellow },
  ['r'] = { mode = 'ENTER', color = colors.yellow },
  ['rm'] = { mode = 'MORE', color = colors.yellow },
  ['r?'] = { mode = 'CONFIRM', color = colors.yellow },
  ['!'] = { mode = 'SHELL', color = colors.yellow },
  ['t'] = { mode = 'TERM', color = colors.yellow },
  ['nt'] = { mode = 'TERM', color = colors.yellow },
  ['no'] = { mode = 'OP', color = colors.white },
  ['nov'] = { mode = 'OP', color = colors.white },
  ['noV'] = { mode = 'OP', color = colors.white },
  ['no'] = { mode = 'OP', color = colors.white },
  ['null'] = { mode = 'NONE', color = colors.white },
}

local components = {
  active = { {}, {}, {} },
  inactive = { {}, {}, {} },
}

-- LEFT

-- vi-mode
components.active[1][1] = {
  provider = function()
    return ' ' .. vi_mode[vim.fn.mode()].mode .. ' '
  end,

  hl = function()
    local val = {}
    val.bg = vi_mode[vim.fn.mode()].color
    val.style = 'bold'
    return val
  end,

}


-- filename
components.active[1][2] = {
  provider = function()
    return " " .. vim.fn.expand("%:F")
  end,

  hl = function()
    local val = {}
    val.fg = vi_mode[vim.fn.mode()].color
    val.bg = colors.bg_dark
    val.style = 'bold'
    return val
  end,
}


-- MID

-- gitBranch
components.active[2][1] = {
  provider = 'git_branch',
  icon = '',
  hl = {
    fg = colors.bg,
    bg = colors.bg_dark,
    style = 'bold'
  },
  right_sep = {
    str = ' ',
    hl = { bg = colors.bg_dark },
  }
}
-- diffAdd
components.active[2][2] = {
  provider = 'git_diff_added',
  hl = {
    fg = '#009900',
    bg = colors.bg_dark,
    style = 'bold'
  },
  icon = '+',
  right_sep = {
    str = ' ',
    hl = { bg = colors.bg_dark },
  }
}
-- diffModfified
components.active[2][3] = {
  provider = 'git_diff_changed',
  hl = {
    fg = "#bbbb00",
    bg = colors.bg_dark,
    style = 'bold'
  },
  icon = '~',
  right_sep = {
    str = ' ',
    hl = { bg = colors.bg_dark },
  }
}
-- diffRemove
components.active[2][4] = {
  provider = 'git_diff_removed',
  hl = {
    fg = "#ff2222",
    bg = colors.bg_dark,
    style = 'bold'
  },
  icon = '-',
  right_sep = {
    str = ' ',
    hl = { bg = colors.bg_dark },
  }

}
-- diagnosticErrors
components.active[2][5] = {
  provider = 'diagnostic_errors',
  hl = {
    fg = 'red',
    bg = colors.bg_dark,
    style = 'bold'
  }
}
-- diagnosticWarn
components.active[2][6] = {
  provider = 'diagnostic_warnings',
  hl = {
    fg = 'yellow',
    bg = colors.bg_dark,
    style = 'bold'
  }
}
-- diagnosticHint
components.active[2][7] = {
  provider = 'diagnostic_hints',
  hl = {
    fg = 'cyan',
    bg = colors.bg_dark,
    style = 'bold'
  }
}
-- diagnosticInfo
components.active[2][8] = {
  provider = 'diagnostic_info',
  hl = {
    fg = 'skyblue',
    bg = colors.bg_dark,
    style = 'bold'
  }
}

-- RIGHT

-- LspName
components.active[3][1] = {
  provider = 'lsp_client_names',
  hl = {
    fg = colors.green,
    bg = colors.bg_dark,
    style = 'bold'
  },
  right_sep = {
    str = '  ',
    hl = { bg = colors.bg_dark },
  }
}
-- fileIcon
components.active[3][2] = {
  provider = function()
    local filename  = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')
    local icon      = require 'nvim-web-devicons'.get_icon(filename, extension)
    if icon == nil then
      icon = ''
    end
    return icon
  end,
  hl = function()
    local val        = {}
    local filename   = vim.fn.expand('%:t')
    local extension  = vim.fn.expand('%:e')
    local icon, name = require 'nvim-web-devicons'.get_icon(filename, extension)
    if icon ~= nil then
      val.fg = vim.fn.synIDattr(vim.fn.hlID(name), 'fg')
    else
      val.fg = 'white'
    end

    val.bg = colors.bg_dark
    val.style = 'bold'
    return val
  end,
  right_sep = {
    str = ' ',
    hl = { bg = colors.bg_dark },
  }
}
-- fileType
components.active[3][3] = {
  provider = function()
    return vim.fn.expand('%:e')
  end,

  hl = function()
    local val        = {}
    local filename   = vim.fn.expand('%:t')
    local extension  = vim.fn.expand('%:e')
    local icon, name = require 'nvim-web-devicons'.get_icon(filename, extension)
    if icon ~= nil then
      val.fg = vim.fn.synIDattr(vim.fn.hlID(name), 'fg')
    else
      val.fg = 'white'
    end
    val.bg = colors.bg_dark
    val.style = 'bold'
    return val
  end,
  right_sep = {
    str = '  ',
    hl = { bg = colors.bg_dark },
  }
}

-- linePercent
components.active[3][4] = {
  provider = 'line_percentage',
  hl = function()
    local val = {}
    val.fg = vi_mode[vim.fn.mode()].color
    val.bg = colors.bg_dark
    val.style = 'bold'
    return val
  end,

  right_sep = {
    str = ' ',
    hl = function()
      local val = {}
      val.fg = vi_mode[vim.fn.mode()].color
      val.bg = colors.bg_dark
      return val
    end,
  }

}

components.active[3][5] = {
  provider = 'position',
  hl = function()
    local val = {}
    val.fg = vi_mode[vim.fn.mode()].color
    val.bg = colors.bg_dark
    val.style = 'bold'
    return val
  end,

}


-- INACTIVE

-- fileType
components.inactive[1][1] = {
  provider = 'file_type',
  hl = {
    fg = colors.blue,
    bg = colors.bg_dark,
    style = 'bold'
  },
}

require('feline').setup({
  components = components,
  force_inactive = {
    filetypes = {
      'NvimTree',
      'packer',
    },
    buftypes = {
      'terminal'
    },
    bufnames = {}
  },
})
