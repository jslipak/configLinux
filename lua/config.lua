require('modes').setup({
	colors = {
		copy = "#f5c359",
		delete = "#c75c6a",
		insert = "#78ccc5",
		visual = "#9745be",
	},

	-- Set opacity for cursorline and number background
	line_opacity = 0.15,

	-- Enable cursor highlights
	set_cursor = true,

	-- Enable cursorline initially, and disable cursorline for inactive windows
	-- or ignored filetypes
	set_cursorline = true,

	-- Enable line number highlights to match cursorline
	set_number = true,

	-- Disable modes highlights in specified filetypes
	-- Please PR commonly ignored filetypes
	ignore_filetypes = { 'NvimTree', 'TelescopePrompt' }
})
require('gitsigns').setup()
require 'colorizer'.setup() 
require("bufferline").setup({
    highlights = {
      background = {
        fg = "#ff5fff",
        bg = "#151e1e",
      },
      fill= {
        fg = "#ff5fff",
        bg = "#151e1e",
      },
      buffer_selected = {
        fg =  "#ff331f",
        bg = '#ffffff',
        bold = true,
        italic = true,
      },
      numbers_selected = {
        fg =  "#ff331f",
        bg =  '#ffffff',
        bold = true,
        italic = true,
      },
    },
    options = {
      always_show_bufferline = true,
      offsets = {
        {
          filetype = "NvimTree",
          text_align = "center",
          separator = true
        }
      },
      show_buffer_close_icons = false,
      hover = {
        enabled = true,
        delay = 200,
        reveal = {'close'}
      },
      numbers = "ordinal",
      indicator = {
        style = "icon"
      },
      color_icons = true,
      separator_style = "tight",
    }
  }
)
require'range-highlight'.setup{}
require'ccc'.setup()
-- fix shades problem when close

require("persisted").setup()
require("telescope").load_extension("persisted")
require('fold-preview').setup()
require("registers").setup()
require('marks').setup()
require('nvim-cursorline').setup ( {
    cursorline = {
      enable = true,
      timeout = 1000,
      number = false,
    },
    cursorword = {
      enable = true,
      min_length = 3,
      hl = { underline = true },
    }
  } )

