local plugins = {
  'wbthomason/packer.nvim',
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  -- Snippets plugin
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },
  "saadparwaiz1/cmp_luasnip",
  -- Snippets source for nvim-cmp
  "rafamadriz/friendly-snippets",
  {
    "chrisgrieser/nvim-scissors",
    dependencies = { "nvim-telescope/telescope.nvim", "L3MON4D3/LuaSnip" },
    opts = {
      snippetDir = "~/configLinux/snippetFolder",
      editSnippetPopup = {
        height = 0.4, -- relative to the window, number between 0 and 1
        width = 0.6,
        border = "rounded",
        keymaps = {
          cancel = "q",
          saveChanges = "<CR>", -- alternatively, can also use `:w`
          goBackToSearch = "<BS>",
          deleteSnippet = "<C-del>",
          duplicateSnippet = "<C-d>",
          openInFile = "<C-o>",
          insertNextPlaceholder= "<C-t>",            -- insert & normal mode
        },
      },
    }
  },
  --
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  {
    "zbirenbaum/copilot.lua",
    verylazy = true,
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        lua = true,
        bash = true,
      },
    },
  }
  ,
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  }
  ,
  -- add copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  -- LSP
  "junnplus/lsp-setup.nvim",
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "nvimtools/none-ls.nvim",
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "prettier", "eslint" },
        automatic_installation = true,
      })
    end,
  },
  "mattn/emmet-vim",
  "dcampos/cmp-emmet-vim",
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  { 'mhartington/formatter.nvim' },
  -- Packer
  -- bnamee
  { "preservim/tagbar" },
  { "tpope/vim-sensible" },
  { "tpope/vim-ragtag" },
  { "tpope/vim-abolish" },
  { "tpope/vim-repeat" },
  { "chrisbra/matchit" },
  { "andrewradev/splitjoin.vim" },
  { "AndrewRadev/sideways.vim" },
  { "andrewradev/switch.vim" },
  { "lukas-reineke/indent-blankline.nvim" },
  "nvim-lua/plenary.nvim",
  {
      "ibhagwan/fzf-lua",
        -- optional for icon support
        --   dependencies = { "nvim-tree/nvim-web-devicons" },
        --     config = function()
          --         -- calling `setup` is optional for customization
          --             require("fzf-lua").setup({})
          --               end
          --               }
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { "folke/zen-mode.nvim" },
  "MunifTanjim/nui.nvim",
  { "rcarriga/nvim-notify" },
  { "folke/noice.nvim" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    "windwp/nvim-autopairs",
    config = true,
    opts = {}
  },
  { "nvim-treesitter/nvim-treesitter" },
  "rrethy/nvim-treesitter-endwise",
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- FIX: Trae probrelam con ctrl-tab y ctrl-i jump foward
  -- {
  --   "roobert/tabtree.nvim",
  --   config = function()
  --     require("tabtree").setup()
  --   end,
  --
  -- },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      -- Disable default tab keybinding in LuaSnip
      return {}
    end,
  },
  {
    "NStefan002/screenkey.nvim",
    cmd = "Screenkey",
    version = "*",
    config = true,
  },
  -- Chrome
  {
    "glacambre/firenvim",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },
  { "famiu/bufdelete.nvim" },
  -- colors and icons
  "ayu-theme/ayu-vim",
  "oxfist/night-owl.nvim",
  "norcalli/nvim-colorizer.lua",
  "uga-rosa/ccc.nvim",
  {
    'olivercederborg/poimandres.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('poimandres').setup {
        -- leave this setup function empty for default config
        -- or refer to the configuration section
        -- for configuration options
      }
    end,

    -- optionally set the colorscheme within lazy config
    init = function()
      vim.cmd("colorscheme poimandres")
    end
  },
  { "uloco/bluloco.nvim",              dependencies = { "rktjmp/lush.nvim" } },
  { "dasupradyumna/midnight.nvim" },
  { "kartikp10/noctis.nvim",           dependencies = { "rktjmp/lush.nvim" } },
  { "lalitmee/cobalt2.nvim",           dependencies = "tjdevries/colorbuddy.nvim" },
  { "zootedb0t/citruszest.nvim" },
  { "astroNvim/astrotheme" },
  { "kihachi2000/yash.nvim" },
  { "water-sucks/darkrose.nvim" },
  { "DeviusVim/deviuspro.nvim" },
  { "datsfilipe/vesper.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "folke/tokyonight.nvim" },
  { "Rigellute/shades-of-purple.vim" },
  { "catppuccin/nvim",                 name = "catppuccin" },
  { "rose-pine/neovim",                name = "rose-pine" },
  { "jascha030/nitepal.nvim" },
  { "projekt0n/caret.nvim" },
  { "ribru17/bamboo.nvim" },
  -- explorer file
  { --nvim-tree explorer
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- lazyional, for file icons
    }
  },
  "ahmedkhalf/project.nvim",
  {
    "otavioschwanck/arrow.nvim",
    opts = {
      show_icons = true,
      always_show_path = true,
      separate_by_branch = true,
      leader_key = ";", -- Recommended to be a single key
      window = { border = "double" },
    }
  },
  -- git
  {
    "kdheepak/lazygit.nvim",
    -- lazyional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  "tpope/vim-fugitive",
  "airblade/vim-gitgutter",
  --status bar
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  }, -- Lua
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {
      keys = 'etovxqpdygfblzhckisuran'
    }
  }
  ,

  -- RUBY
  "vim-ruby/vim-ruby",
  "kurtpreston/vim-autoformat-rails",
  "tpope/vim-rails",
  { "stevearc/dressing.nvim" },
  "weizheheng/ror.nvim",
  "tpope/vim-endwise",
  "tpope/vim-cucumber",
  "tpope/vim-bundler",
  "gmarik/Vundle.vim",
  "slim-template/vim-slim",
  "metakirby5/codi.vim",
  "tpope/vim-rvm",

  -- GO
  "fatih/vim-go",

  --Sessions
  {
    "olimorris/persisted.nvim",
    lazy = false, -- make sure the plugin is always loaded at startup
    config = true
  }
  ,
  --Tab and windows
  { "alvarosevilla95/luatab.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
  { "yorickpeterse/nvim-window" },
  { 'akinsho/bufferline.nvim',     version = "*",                               dependencies = 'nvim-tree/nvim-web-devicons' },
  -- Test
  "vim-test/vim-test",
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zidhuss/neotest-minitest",
      "olimorris/neotest-rspec",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "marilari88/neotest-vitest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-minitest")({
            test_cmd = function()
              return vim.tbl_flatten({
                "bundle",
                "exec",
                "rails",
                "test",
              })
            end,
          }),
          require("neotest-rspec"),
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-go"),
          require("neotest-python"),
          require("neotest-vitest"),
        },
      })
    end,
  },
  --UI
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    "bennypowers/nvim-regexplainer",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
  },
  "winston0410/cmd-parser.nvim",
  "winston0410/range-highlight.nvim",
  "yamatsum/nvim-cursorline",
  "anuvyklack/pretty-fold.nvim",
  {
    "tversteeg/registers.nvim",
    cmd = "Registers",
    config = true,
    keys = {
      { "\"",    mode = { "n", "v" } },
      { "<C-R>", mode = "i" }
    },
    name = "registers",
  }
  ,
  -- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
  }
  ,{
      "folke/which-key.nvim",
        event = "VeryLazy",
          init = function()
                vim.o.timeout = true
                    vim.o.timeoutlen = 300
                      end,
                        opts = {
                              -- your configuration comes here
                              --     -- or leave it empty to use the default settings
                              --       }
                              --       }
                        }
  } ,
  "goolord/alpha-nvim",
  "sunjon/shade.nvim",
  {
    "mvllow/modes.nvim",
    versions = "v0.2.0",
    opts = {
      colors = {
        copy = "#f5c359",
        delete = "#c75c6a",
        insert = "#3581B8",
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
      -- Plenamee PR commonly ignored filetypes
      ignore_filetypes = { "NvimTree", "TelescopePrompt" },
    }
  },
  { 'akinsho/toggleterm.nvim', version = "*", opts = { --[[ things you want to change go here]] } }
  ,
  { "sitiom/nvim-numbertoggle" },
}

require("lazy").setup(plugins)
