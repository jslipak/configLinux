vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- You add plugins here  
  -- Packer
  -- base
  use "nvim-lua/plenary.nvim"
  use "MunifTanjim/nui.nvim"

   -- ChatGPT, Autocomplete 
  use({
    "jackMort/ChatGPT.nvim",
      config = function()
        require("chatgpt").setup({
          -- optional configuration
        })
      end,
      requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
      }
  })

  -- colors and icons
  use 'kyazdani42/nvim-web-devicons'
  use 'norcalli/nvim-colorizer.lua'
  use 'uga-rosa/ccc.nvim'

  -- git
  use 'lewis6991/gitsigns.nvim' 

   --status bar
   use ({ 'nvim-lualine/lualine.nvim',
       requires = { 'kyazdani42/nvim-web-devicons', opt = true }
     }) 
  use 'feline-nvim/feline.nvim'
  use "yorik1984/lualine-theme.nvim" -- newpaper-[dark, light], theme 

  --Sessions
  use({ "olimorris/persisted.nvim",
  --module = "persisted", -- For lazy loading
  config = function()
    require("persisted").setup()
    require("telescope").load_extension("persisted") -- To load the telescope extension
  end,
})
  --Tab
  use { 'alvarosevilla95/luatab.nvim', requires='kyazdani42/nvim-web-devicons' }
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}

  --UI
  use 'winston0410/cmd-parser.nvim'
  use 'winston0410/range-highlight.nvim'
  use 'sunjon/shade.nvim'
  use 'yamatsum/nvim-cursorline'
  use ({ 'anuvyklack/fold-preview.nvim',
      requires = 'anuvyklack/keymap-amend.nvim',
      config = function()
        require('fold-preview').setup()
      end
    })
  use ({ "tversteeg/registers.nvim", config = function() require("registers").setup() end, }) 
  use 'chentoast/marks.nvim'
  use({
	'mvllow/modes.nvim',
	tag = 'v0.2.0',
	config = function()
		require('modes').setup()
	end
  })
end)
