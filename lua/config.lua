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
require("persisted").setup()
require("telescope").load_extension("persisted")
require('fold-preview').setup()
require("registers").setup()
require('marks').setup()
require('nvim-cursorline').setup({
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
    })
require'regexplainer'.setup( {
    -- 'narrative'
    mode = 'narrative', -- TODO: 'ascii', 'graphical'

    -- automatically show the explainer when the cursor enters a regexp
    auto = false,

    -- filetypes (i.e. extensions) in which to run the autocommand
    filetypes = {
      'html',
      'js',
      'cjs',
      'mjs',
      'ts',
      'jsx',
      'tsx',
      'cjsx',
      'mjsx',
      'rb',
      'erb'
    },

    -- Whether to log debug messages
    debug = false, 

    -- 'split', 'popup'
    display = 'popup',

    mappings = {
      toggle = 'gR',
      -- examples, not defaults:
      -- show = 'gS',
      -- hide = 'gH',
      -- show_split = 'gP',
      -- show_popup = 'gU',
    },

    narrative = {
      separator = '\n',
    },
  } )
-- config nvim-tree 
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    side  = "right"
    --mappings = {
      --list = {
        --{ key = "u", action = "dir_up" },
      --},
    --},
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
require("which-key").setup( { plugins = { marks = false,  registers = false}})
require('Comment').setup()
require("nvim-surround").setup()
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust", "bash", "css","diff", "dockerfile","html", "javascript","python", "regex", "ruby", "typescript" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
require("alpha").setup(require("alpha_themes/theta").config)
-- FIX: shades ,MODES
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
