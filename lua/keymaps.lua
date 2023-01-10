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
map('i', '<M-:>', '<C-O>:Copilot Panel<CR>')
-- F 
map('n', '<F3>', ':set invpaste paste?<CR>')
vim.opt.pastetoggle = '<F3>'
map('n', '<F12>', ':Codi!!<CR>')
map('n', '<F7>', ':call ToggleSpellCheck()<CR>')
map('n', '<F8>', ':TagbarToggle<CR>')
map('n', '<F6>', ':NvimTreeToggle<CR>')

-- Git
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

--Help
map('n', '<leader>hm', ':Telescope man_pages')
map('n', '<leader>hv', ':Telescope help_tags')
map('n', '<leader>hz', ':Telescope spell_suggest')
map('n', '<leader>hd', ':Dasht<space>')
map('n', '<leader>hD', ':Dasht!<space>')


-- Insert mode
map('i', '<C-e>', '<ESC>A')
map('i', '<C-a>', '<ESC>I')
map('i', '<M-h>', '<C-O>:SidewaysLeft<CR>')
map('i', '<M-l>', '<C-O>:SidewaysRight<CR>')
map('i', '<C-s>', '<C-O>w<CR>')



-- Movement
 -- map('n', '<c-h>', '<c-w>h')
 -- map('n', '<c-j>', '<c-w>j')
 -- map('n', '<c-k>', '<c-w>k')
 -- map('n', '<c-l>', '<c-w>l')
map('n', '<leader>ma', ':HopAnywhere<CR>')
map('n', '<leader>m1', ':HopChar1<CR>')
map('n', '<leader>m2', ':HopChar2<CR>')
map('n', '<leader>ml', ':HopLine<CR>')
map('n', '<leader>ms', ':HopLineStart<CR>')
map('n', '<leader>mv', ':HopVertical<CR>')
map('n', '<leader>mp', ':HopPattern<CR>')
map('n', '<leader>mw', ':HopWord<CR>')
map('i', '<C-j>', '<C-o>:HopChar1<CR>')

-- Nomal mode
map('n', '<M-h>', ':SidewaysLeft<CR>')
map('n', '<M-l>', ':SidewaysRight<CR>')
map('n', '<C-s>', ':w<CR>')

-- Panels
map('n', '<leader>pf', ':Files<CR>')
map('n', '<leader>pF', ':Rg<CR>')
map('n', '<leader>pm', ':Marks<CR>')
map('n', '<leader>pk', ':Telescope keymaps<CR>')
map('n', '<leader>ps', ':Telescope persisted<CR>') 
map('n', '<leader>pt', ':Telescope tags<CR>')
map('n', '<leader>pr', ':Telescope registers<CR>')
map('n', '<leader>pb', ':Telescope buffers<CR>')
map('n', '<leader>pj', ':Telescope jumplist<CR>')
map('n', '<leader>pT', ':Telescope<CR>')

-- Tab
map('n', 'gt', ':bnext<CR>')
map('n', 'gT', ':bprevious<CR>')
map('n', '<leader>mt', ':BufferLinePick<CR>')
map('n', '<F4>', ':BufferLinePickClose<CR>')
map('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>')
map('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>')
map('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>')
map('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>')
map('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>')
map('n', '<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>')
map('n', '<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>')
map('n', '<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>')
map('n', '<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>')

-- Vim Config
map('n', '<leader>sr', ':so ~/.config/nvim/init.vim<CR>') 
map('n', '<leader>si', ':tabnew ~/.config/nvim/init.vim<CR>') 
map('n', '<leader>sc', ':tabnew ~/.config/nvim/lua/config.lua<CR>') 
map('n', '<leader>sp', ':tabnew ~/.config/nvim/lua/plugins.lua<CR>') 
map('n', '<leader>sk', ':tabnew ~/.config/nvim/lua/keymaps.lua<CR>') 
map('n', '<leader>sn', ':set rnu!<CR>')
map('n', '<leader>so', ':Telescope vim_options<CR>')

-- Visual Mode
-- map('v', 'J', ":m '>+1<CR>gv=gv'")
-- map('v', 'K', ":m '<-2<CR>gv=gv'")

-- Quit, Exit and Save
map('n', '<leader>qt', ':bd<CR>')
map('n', '<leader>qv', ':qa<CR>')
map('n', '<leader>q!', ':qa!<CR>')
map('n', '<leader>qw', ':wq<CR>')

-- Zen Mode
map('n', '<leaden>z', ':Goyo 120<CR>')

