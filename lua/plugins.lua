vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- You add plugins here
	--auto complete
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use("L3MON4D3/LuaSnip")        -- Snippets plugin
	use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
	use("rafamadriz/friendly-snippets")
	use({
		"chrisgrieser/nvim-scissors",
		dependencies = "nvim-telescope/telescope.nvim", -- optional
		config = function()
			require("scissors").setup({
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
						insertNextToken = "<C-t>",      -- insert & normal mode
						jumpBetweenBodyAndPrefix = "<C-Tab>", -- insert & normal mode
					},
				},
			})
		end,
	})
	--
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")
	use({ "zbirenbaum/copilot.lua" })
	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	})
	-- add copilot chat
	use({
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true,
			-- your options here
		},
	})

	-- LSP
	use({
		"junnplus/lsp-setup.nvim",
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"jose-elias-alvarez/null-ls.nvim",
		"jay-babu/mason-null-ls.nvim",
	})
	use("mattn/emmet-vim")
	use("dcampos/cmp-emmet-vim")

	use({
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	-- Packer
	-- base
	use({ "preservim/tagbar" })
	use({ "tpope/vim-sensible" })
	use({ "tpope/vim-ragtag" })
	use({ "tpope/vim-abolish" })
	use({ "tpope/vim-repeat" })
	use({ "chrisbra/matchit" })
	use({ "andrewradev/splitjoin.vim" })
	use({ "AndrewRadev/sideways.vim" })
	use({ "andrewradev/switch.vim" })
  use({ "lukas-reineke/indent-blankline.nvim" })
	use("nvim-lua/plenary.nvim")
	use({
		"ibhagwan/fzf-lua",
		-- optional for icon support
		requires = { "nvim-tree/nvim-web-devicons" },
	})
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "folke/zen-mode.nvim" })
	use("MunifTanjim/nui.nvim")
	use({ "rcarriga/nvim-notify" })
	use({ "folke/noice.nvim" })
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use({
		"ZhiyuanLck/smart-pairs",
		event = "InsertEnter",
		config = function()
			require("pairs"):setup()
		end,
	})
	use({ "nvim-treesitter/nvim-treesitter" })
	use("rrethy/nvim-treesitter-endwise")
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use({
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	})
  -- Lua
use {
  'abecodes/tabout.nvim',
  config = function()
    require('tabout').setup {
    tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
    backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
    act_as_tab = true, -- shift content if tab out is not possible
    act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
    default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
    default_shift_tab = '<C-d>', -- reverse shift default action,
    enable_backwards = true, -- well ...
    completion = true, -- if the tabkey is used in a completion pum
    tabouts = {
      {open = "'", close = "'"},
      {open = '"', close = '"'},
      {open = '`', close = '`'},
      {open = '(', close = ')'},
      {open = '[', close = ']'},
      {open = '{', close = '}'}
    },
    ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
    exclude = {} -- tabout will ignore these filetypes
}
  end,
	wants = {'nvim-treesitter'}, -- (optional) or require if not used so far
	after = {'nvim-cmp'} -- if a completion plugin is using tabs load it before
}
	-- Chrome
	use({
		"glacambre/firenvim",
		run = function()
			vim.fn["firenvim#install"](0)
		end,
	})
	use({ "famiu/bufdelete.nvim" })
	-- colors and icons
	use("ayu-theme/ayu-vim")
	use("kyazdani42/nvim-web-devicons")
	use("oxfist/night-owl.nvim")
	use("norcalli/nvim-colorizer.lua")
	use("uga-rosa/ccc.nvim")
	use({
		"olivercederborg/poimandres.nvim",
		config = function()
			require("poimandres").setup({})
		end,
	})
	use({ "uloco/bluloco.nvim", requires = { "rktjmp/lush.nvim" } })
	use({ "dasupradyumna/midnight.nvim" })
	use({ "kartikp10/noctis.nvim", requires = { "rktjmp/lush.nvim" } })
	use({ "lalitmee/cobalt2.nvim", requires = "tjdevries/colorbuddy.nvim" })
	use({ "zootedb0t/citruszest.nvim" })
	use({ "AstroNvim/astrotheme" })
	use({ "kihachi2000/yash.nvim" })
	use({ "water-sucks/darkrose.nvim" })
	use({ "DeviusVim/deviuspro.nvim" })
	use({ "datsfilipe/vesper.nvim" })
	use({ "rebelot/kanagawa.nvim" })
	use({ "nyoom-engineering/oxocarbon.nvim" })
	use({ "folke/tokyonight.nvim" })
	use({ "Rigellute/shades-of-purple.vim" })
	use({ "catppuccin/nvim", as = "catppuccin" })
	use({ "rose-pine/neovim", as = "rose-pine" })
	use({ "jascha030/nitepal.nvim" })
	use({ "projekt0n/caret.nvim" })
	use({ "ribru17/bamboo.nvim" })
	-- explorer file
	use({ --nvim-tree explorer
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		tag = "nightly",              -- optional, updated every week. (see issue #1193)
	})
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	-- use("ThePrimeagen/harpoon")
	use({
		"otavioschwanck/arrow.nvim",
		config = function()
			require("arrow").setup({
				show_icons = true,
				always_show_path = true,
				separate_by_branch = true,
				leader_key = ";", -- Recommended to be a single key
				window = { border = "double" },
			})
		end,
	})
	-- git
	use({
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	use("tpope/vim-fugitive")
	use("airblade/vim-gitgutter")
	--status bar
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		theme = "tokyonight",
	})
	use("feline-nvim/feline.nvim")
	use("yorik1984/lualine-theme.nvim") -- newpaper-[dark, light], theme

	--Motion
	use({
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	})

	-- RUBY
	use("vim-ruby/vim-ruby")
	use("kurtpreston/vim-autoformat-rails")
	use("tpope/vim-rails")
	use({ "stevearc/dressing.nvim" })
	use("weizheheng/ror.nvim")
	use("tpope/vim-endwise")
	use("tpope/vim-cucumber")
	use("tpope/vim-bundler")
	use("gmarik/Vundle.vim")
	use("slim-template/vim-slim")
	use("metakirby5/codi.vim")
	use("tpope/vim-rvm")

	-- GO
	use("fatih/vim-go")

	--Sessions
	use({
		"olimorris/persisted.nvim",
		--module = "persisted", -- For lazy loading
		config = function()
			require("persisted").setup()
			require("telescope").load_extension("persisted") -- To load the telescope extension
		end,
	})
	--Tab and windows
	use({ "alvarosevilla95/luatab.nvim", requires = "kyazdani42/nvim-web-devicons" })
	use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons" })
	use({ "yorickpeterse/nvim-window" })
	-- Test
	use("vim-test/vim-test")
	use({
		"nvim-neotest/neotest",
		requires = {
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
	})

	--UI
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	use({
		"bennypowers/nvim-regexplainer",
		config = function()
			require("regexplainer").setup()
		end,
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"MunifTanjim/nui.nvim",
		},
	})
	use("winston0410/cmd-parser.nvim")
	use("winston0410/range-highlight.nvim")
	use("yamatsum/nvim-cursorline")
	use({
		"anuvyklack/pretty-fold.nvim",
		config = function()
			require("pretty-fold").setup()
		end,
	})
	use({
		"tversteeg/registers.nvim",
		config = function()
			require("registers").setup()
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				plugins = {
					marks = true, -- shows a list of your marks on ' and `
					registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				},
			})
		end,
	})
	use("goolord/alpha-nvim")

	use("sunjon/shade.nvim")
	use({
		"mvllow/modes.nvim",
		tag = "v0.2.0",
		config = function()
			require("modes").setup({
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
				-- Please PR commonly ignored filetypes
				ignore_filetypes = { "NvimTree", "TelescopePrompt" },
			})
		end,
	})
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("toggleterm").setup()
		end,
	})
	use({ "sitiom/nvim-numbertoggle" })
end)
