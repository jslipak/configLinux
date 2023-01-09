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

-- COC.Nvim
map('n', 'cp', '<Plug>(coc-diagnostic-prev)')
map('n', 'cn', '<Plug>(coc-diagnostic-next)')
map('n', 'gd', '<Plug>(coc-definition)')
map('n', 'gy', '<Plug>(coc-type-definition)')
map('n', 'gi', '<Plug>(coc-implementation)')
map('n', 'gr', '<Plug>(coc-references)')
map('n', 'ca', ':CocAction<CR>')
map('x', 'ca', ':CocAction<CR>')
map('n', 'cf', '<Plug>(coc-fix-current)')
-- TODO add: inoremap <silent><expr> <C-Space> coc#select()

-- Copilot
-- TODO: imap <silent><script><expr> <M-j> copilot#Accept("\<CR>")
map('i', '<M-,>', '<Plug>(copilot-previous)')
map('i', '<M-.>', '<Plug>(copilot-next)')
map('i', '<M-;>', '<Plug>(copilot-suggest)')
map('i', '<M-:>', '<Plug>(copilot-previous)')
-- F 
map('n', '<F12>', ':Codi!!<CR>')
map('n', '<F7>', ':call ToggleSpellCheck()<CR>')
map('n', '<F8>', ':TagbarToggle<CR>')
map('n', '<F6>', ':NvimTreeToggle<CR>')

--Git
map('n', '<leader>g.' , ':G<CR>')
map('n', '<leader>gf', ':GFiles<CR>')
map('n', '<leader>gd', ':Gdiffsplit<CR>')
map('n', '<leader>gl', ':diffget //3<CR>')
map('n', '<leader>gh', ':difffet //2<CR>')
map('n', '<leader>gc', ':GCheckout<CR>')
map('n', '<leader>gn', '<Plug>(GitGutterNextHunk)')
map('n', '<leader>gp', '<Plug>(GitGutterPrevHunk)')
map('n', '<leader>gs', '<Plug>(GitGutterStageHunk)')
map('n', '<leader>gu', '<Plug>(GitGutterUndoHunk)')
map('n', '<leader>gw', '<Plug>(GitGutterPreviewHunk)')
map('n', '<leader>gb', ':GitBlameToggle<CR>')
map('n', '<leader>gt.', ':Telescope git_satus<CR>')
map('n', '<leader>gts', ':Telescope git_stash<CR>')
map('n', '<leader>gtb', ':Telescope git_branches<CR>')
map('n', '<leader>gtco', ':Telescope git_commits<CR>')
map('n', '<leader>gtcb', ':Telescope git_bcommits<CR>')
map('n', '<leader>gtf', ':Telescope git_files<CR>')

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


