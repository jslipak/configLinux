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
require('marks').setup(
  {  
    mappings={
    set_next = "<C-m>",
  }
})
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
require'regexplainer'.setup({
    -- 'narrative'
    mode = 'narrative', -- TODO: 'ascii', 'graphical'

    -- automatically show the explainer when the cursor enters a regexp
    auto = true,

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
    display = 'split',

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

require('which-key').setup({
	plugins = {
		presets = {
			operators = false,
		},
	},
})
require('Comment').setup()
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust", "bash", "css","diff", "dockerfile","html", "javascript","python", "regex", "ruby", "typescript" },
   endwise = {
        enable = true,
    },
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
  endwise = {
        enable = true,
    },
}
require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
require("alpha").setup(require("alpha_themes/theta").config)
require("registers").setup()
require("todo-comments").setup {}
-- require("nvim-autopairs").setup {}

-- TODO: shades ,MODES
require('modes').setup({
	colors = {
  copy = "#f5c359",
		delete = "#c75c6a",
		insert = "#78ccc5",
		visual = "#9745be",
	},

	-- Set opacity for cursorline and number background
	line_opacity = 0.55,

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
require("harpoon").setup()
require("telescope").load_extension('harpoon')
require("mason").setup()
require("mason-lspconfig").setup()
require("nvim-lsp-installer").setup {}
require('lspconfig')['solargraph'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['ruby_ls'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['sorbet'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}

require('lspconfig')['eslint'].setup({
  --- ...
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

local cmp = require'cmp'
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
