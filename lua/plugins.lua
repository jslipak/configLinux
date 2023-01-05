vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- You add plugins here  
  -- Packer
  -- icons and colors
  use 'NvChad/nvim-colorizer.lua'
  use "nvim-tree/nvim-web-devicons"
  -- Plenary
  use "nvim-lua/plenary.nvim"
  use "MunifTanjim/nui.nvim"
  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  --status bar
  use {
   'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use 'feline-nvim/feline.nvim'

  --status bar theme
  use "yorik1984/lualine-theme.nvim" -- newpaper-[dark, light]
  
  --Tab
  use { 'alvarosevilla95/luatab.nvim', requires='kyazdani42/nvim-web-devicons' }
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}

  -- git
  use {
  'lewis6991/gitsigns.nvim',
  -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
  }
  -- ChatGPT
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
end)
