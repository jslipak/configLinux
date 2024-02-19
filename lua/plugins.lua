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
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
	use("rafamadriz/friendly-snippets")
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
	-- LSP
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"jose-elias-alvarez/null-ls.nvim",
		"jay-babu/mason-null-ls.nvim",
	})

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
	use("nvim-lua/plenary.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("MunifTanjim/nui.nvim")
	use({ "rcarriga/nvim-notify" })
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
	use({ "nvim-treesitter/nvim-treesitter" })
	use("rrethy/nvim-treesitter-endwise")
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})
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

	-- explorer file
	use({ --nvim-tree explorer
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
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
	use("tpope/vim-fugitive")
	use("airblade/vim-gitgutter")
	use("mhinz/vim-signify")
	--status bar
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
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
	use("tpope/vim-endwise")
	use("ngmy/vim-rubocop")
	use("tpope/vim-cucumber")
	use("tpope/vim-bundler")
	use("janko-m/vim-test")
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
		"anuvyklack/fold-preview.nvim",
		requires = "anuvyklack/keymap-amend.nvim",
		config = function()
			require("fold-preview").setup()
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
