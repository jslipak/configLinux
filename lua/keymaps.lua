-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to a comma
vim.g.mapleader = ' '

-- Toggle auto-indenting for code paste
map('n', '<F3>', ':set invpaste paste?<CR>')
vim.opt.pastetoggle = '<F3>'

-- Move around splits using Ctrl + {h,j,k,l}
 map('n', '<c-h>', '<c-w>h')
 map('n', '<c-j>', '<c-w>j')
 map('n', '<c-k>', '<c-w>k')
 map('n', '<c-l>', '<c-w>l')

-- F 
map('n', '<F12>', ':Codi!!<CR>')
map('n', '<F7>', ':call ToggleSpellCheck()<CR>')
map('n', '<F8>', ':TagbarToggle<CR>')
map('n', '<F6>', ':NvimTreeToggle<CR>')

--Git
map('n', '<leader>g.' , ':G<CR>')

-- Panels
map('n', '<leader>pe', ':Files<CR>')
map('n', '<leader>pr', ':Rg<CR>')
map('n', '<leader>pm', ':Marks<CR>')
map('n', '<leader>pk', ':Telescope keymaps<CR>')
map('n', '<leader>ps', ':Telescope persisted<CR>') 

--Sessions
map('n', '<leader>pt', ':Telescope tags<CR>')
map('n', '<leader>pr', ':Telescope registers<CR>')
map('n', '<leader>pb', ':Telescope buffers<CR>')
map('n', '<leader>pj', ':Telescope jumplist<CR>')


-- Tab
map('n', '>', ':bnext<CR>')
map('n', '<', ':bprevious<CR>')
map('n', '<C-I>', ':BufferLinePick<CR>')
map('n', '<C-X>', ':BufferLinePickClose<CR>')

-- Vim Config
map('n', '<leader>sr', ':so ~/.config/nvim/init.vim<CR>') 
map('n', '<leader>si', ':tabnew ~/.config/nvim/init.vim<CR>') 
map('n', '<leader>sc', ':tabnew ~/.config/nvim/lua/config.lua<CR>') 
map('n', '<leader>sp', ':tabnew ~/.config/nvim/lua/plugins.lua<CR>') 
map('n', '<leader>sk', ':tabnew ~/.config/nvim/lua/keymaps.lua<CR>') 
map('n', '<leader>sn', ':set rnu!<CR>')
map('n', '<leader>so', ':Telescope vim_options<CR>')

-- Helps

-- Quit, Exit and Save


