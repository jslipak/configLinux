-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to a comma
vim.g.mapleader = " "

-- CopilotChat
map("n", "<leader>c", '', {desc= "CopilotChat"})
map("n", "<leader>cc", ':CopilotChat<CR>', {desc= "Open CopilotChat"})
map("n", "<leader>ct", ':CopilotChatToggle<CR>', {desc= "Toggle CopilotChat"})
map("n", "<leader>cd", ':CopilotChatDebugInfo<CR>', {desc= "Debug CopilotChat"})
map("n", "<leader>ce", ':CopilotChatExplain<CR>', {desc= "Explain CopilotChat"})
map("n", "<leader>cT", ':CopilotChatTests<CR>', {desc= "Test CopilotChat"})
map("n", "<leader>cf", ':CopilotChatFix<CR>', {desc= "Fix CopilotChat"})
map("n", "<leader>co", ':CopilotChatOptimize<CR>', {desc= "Optimize Selected Code CopilotChat"})
map("n", "<leader>cD", ':CopilotChatDocs<CR>', {desc= "Write documentation for the selected code"})
map("n", "<leader>cF", ':CopilotChatFixDiagnostic<CR>', {desc= "assist with the following diagnostic issue in file"})
map("n", "<leader>cg", ':CopilotChatCommit<CR>', {desc= "Write commit message for the change "})
map("n", "<leader>cG", ':CopilotChatCommitStaged<CR>', {desc= "Write commit message for the change Stage"})
map("n", "<leader>cq", ':CopilotChatClose<CR>', {desc= "Close Copilot Chat"})



-- F
map("n", "<F3>", ":set invpaste paste?<CR>")
vim.opt.pastetoggle = "<F3>"
map("n", "<F12>", ":Codi!!<CR>")
map("n", "<F7>", ":call ToggleSpellCheck()<CR>")
map("n", "<F8>", ":TagbarToggle<CR>")
map("n", "<F6>", ":NvimTreeToggle<CR>")

-- Git
map("n", "<leader>g.", ":G<CR>")
map("n", "<leader>gf", ":GFiles<CR>")
map("n", "<leader>gd", ":Gdiffsplit<CR>")
map("n", "<leader>gl", ":diffget //3<CR>")
map("n", "<leader>gh", ":difffet //2<CR>")
map("n", "<leader>gc", ":GCheckout<CR>")
map("n", "<leader>gn", "<Plug>(GitGutterNextHunk)")
map("n", "<leader>gp", "<Plug>(GitGutterPrevHunk)")
map("n", "<leader>gs", "<Plug>(GitGutterStageHunk)")
map("n", "<leader>gu", "<Plug>(GitGutterUndoHunk)")
map("n", "<leader>gw", "<Plug>(GitGutterPreviewHunk)")
map("n", "<leader>gb", ":G blame<CR>")
map("n", "<leader>gt.", ":Telescope git_satus<CR>")
map("n", "<leader>gts", ":Telescope git_stash<CR>")
map("n", "<leader>gtb", ":Telescope git_branches<CR>")
map("n", "<leader>gtco", ":Telescope git_commits<CR>")
map("n", "<leader>gtcb", ":Telescope git_bcommits<CR>")
map("n", "<leader>gtf", ":Telescope git_files<CR>")

--Help
map("n", "<leader>hm", ":Telescope man_pages")
map("n", "<leader>hv", ":Telescope help_tags")
map("n", "<leader>hz", ":Telescope spell_suggest")
map("n", "<leader>hd", ":Dasht<space>")
map("n", "<leader>hD", ":Dasht!<space>")

-- Insert mode
map("i", "<C-e>", "<ESC>A")
map("i", "<C-a>", "<ESC>I")
map("i", "<C-h>", "<C-O>:SidewaysLeft<CR>")
map("i", "<C-l>", "<C-O>:SidewaysRight<CR>")
map("i", "<M-s>", "<C-c>:w<CR>")
-- Movement
map("n", "<leader>ma", ":HopAnywhere<CR>")
map("n", "<leader>m1", ":HopChar1<CR>")
map("n", "<leader>m2", ":HopChar2<CR>")
map("n", "<leader>ml", ":HopLine<CR>")
map("n", "<leader>ms", ":HopLineStart<CR>")
map("n", "<leader>mv", ":HopVertical<CR>")
map("n", "<leader>mp", ":HopPattern<CR>")
map("n", "<leader>mw", ":HopWord<CR>")
map("i", "<C-j>", "<C-o>:HopChar1<CR>")
map("n", "<leader>w", ":lua require('nvim-window').pick()<CR>",{desc = 'Pick a window'})
-- Nomal mode
map("n", "<C-h>", ":SidewaysLeft<CR>")
map("n", "<C-l>", ":SidewaysRight<CR>")
map("n", "<C-j>", ":HopChar1<CR>")
map("n", "<leader>o", 'o<Esc>0"_D', {desc= "Insert line Below"})
map("n", "<leader>O", 'O<Esc>0"_D', {desc= "Insert line Above" })
map("n", "<M-s>", ":w<CR>")

-- Panels
map("n", "<leader>pf", ":Telescope fd<CR>")
map("n", "<leader>pF", ":Telescope live_grep<CR>")
map("n", "<leader>pm", ":Marks<CR>")
map("n", "<leader>pk", ":Telescope keymaps<CR>")
map("n", "<leader>ps", ":Telescope persisted<CR>")
map("n", "<leader>pt", ":Telescope tags<CR>")
map("n", "<leader>pr", ":Telescope registers<CR>")
map("n", "<leader>pb", ":Telescope buffers<CR>")
map("n", "<leader>pj", ":Telescope jumplist<CR>")
map("n", "<leader>pT", ":Telescope<CR>")
map("n", "<leader>pp", ":Telescope projects<CR>")
map("n", "<leader>t", ":TodoTelescope<CR>")
map("n", "<leader>pc", ":Telescope colorscheme<CR>")

--LSP information
map("n", "<leader>li", "<cmd>LspInfo<CR>")
-- show me a popup with the error , not use frecuntly because the linter show me the error
map("n", "<space>le", "<cmd>lua vim.diagnostic.open_float()<cr>")
-- Window show list of errors
map("n", "<space>ll", "<cmd>lua vim.diagnostic.setloclist()<cr>") 
-- Jump to the definition into function or scope
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
map("n", "<leader>lgd", "<cmd>lua vim.lsp.buf.definition()<cr>")
-- Jumps to the definition of the type symbol
map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
map("n", "<leader>lgo", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
-- Jump to declaration
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
map("n", "<leader>lgD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
-- Lists all the implementations for the symbol under the cursor
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
map("n", "<leader>lgi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
-- Lists all the references
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>")
-- Displays a function's signature information
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
map("n", "<leader>lh", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
-- Displays hover information about the symbol under the cursor
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
map("n", "<leader>lk", "<cmd>lua vim.lsp.buf.hover()<cr>")

vim.keymap.set("n", "<leader>e", function() require("scissors").editSnippet() end, {desc = 'Snippet Menu'})
-- When used in visual mode prefills the selection as body.
vim.keymap.set({ "n", "x" }, "<leader>a", function() require("scissors").addNewSnippet() end, {desc = "Snippet Add"})

-- Renames all references to the symbol under the cursor
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>")
map("n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>")
-- Selects a code action available at the current cursor position
map("n", "<F5>", "<cmd>lua vim.lsp.buf.code_action()<cr>")
map("x", "<F5>", "<cmd>lua vim.lsp.buf.code_action()<cr>")
map("n", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<cr>")
map("x", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<cr>")
-- Show diagnostics in a floating window
map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
-- Move to the previous diagnostic
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
map("n", "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
-- Move to the next diagnostic
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
map("n", "<leader>ln", "<cmd>lua vim.diagnostic.goto_next()<cr>")
-- Show all the symbol, Symbols are special keywords in your code such as variables, functions, etc. To get a list of the symbols, execute the command
map("n", "<leader>ls", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
-- workspace
map("n", "<leader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
map("n", "<leader>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
map("n", "<leader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
-- formating
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
-- null-ls all keybindign
map("n", "<leader>lF", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
-- Format selected text using LSP client
--FIX: problem shortcut
map("v", "<leader>lF", '<cmd>lua vim.lsp.buf.format(vim.fn.getpos("\'<"), vim.fn.getpos("\'>")', opts)

map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
map("n", "<leader>xR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

vim.api.nvim_set_keymap("i", "<M-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<M-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<M-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<M-p>", "<Plug>luasnip-prev-choice", {})

-- Tab
map("n", "gt", ":bnext<CR>")
map("n", "gT", ":bprevious<CR>")
map("n", "<leader>mt", ":BufferLinePick<CR>")
map("n", "<F4>", ":BufferLinePickClose<CR>")
map("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>",{desc = 'go Tab1'})
map("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>",{desc = 'go Tab2'})
map("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>",{desc = 'go Tab3'})
map("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>",{desc = 'go Tab4'})
map("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>",{desc = 'go Tab5'})
map("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>",{desc = 'go Tab6'})
map("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>",{desc = 'go Tab7'})
map("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>",{desc = 'go Tab8'})
map("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>",{desc = 'go Tab9'})

-- Todos
map("n", "<leader>t", ":TodoTelescope<CR>")

-- Vim Config
map("n", "<leader>sr", ":so ~/.config/nvim/init.vim<CR>")
map("n", "<leader>si", ":tabnew ~/.config/nvim/init.vim<CR>")
map("n", "<leader>sc", ":tabnew ~/.config/nvim/lua/config.lua<CR>")
map("n", "<leader>sg", ":tabnew ~/.config/nvim/lua/generals.lua<CR>")
map("n", "<leader>sp", ":tabnew ~/.config/nvim/lua/plugins.lua<CR>")
map("n", "<leader>sk", ":tabnew ~/.config/nvim/lua/keymaps.lua<CR>")
map("n", "<leader>sl", ":tabnew ~/.config/nvim/lua/lsp_config.lua<CR>")
map("n", "<leader>sa", ":tabnew ~/.config/nvim/lua/cmp_config.lua<CR>")
map("n", "<leader>ss", ":tabnew ~/.config/nvim/lua/snippet_config.lua<CR>")
map("n", "<leader>sn", ":set rnu!<CR>")
map("n", "<leader>so", ":Telescope vim_options<CR>")

-- Move lines
map("n", "<M-j>", ":m .+1<CR>==", {desc= "move line(s) down"})
map("n", "<M-k>", ":m .-2<CR>==", {desc= "move line(s) up"})
-- Move lines visual mode
map("v", "<M-j>", ":m '>+1<CR>gv=gv", {desc = "move line(s) down"})
map("v", "<M-k>", ":m '<-2<CR>gv=gv", {desc = "move line(s) up"})
-- add in visual mode when press leader f find as live grep the select 
map('v', '<leader>f', 'y<ESC>:Telescope live_grep default_text=<c-r>0<CR>')
-- toggel terminal
map("n", "<C-\\>", ":ToggleTerm direction=float<CR>")
map("t", "<C-\\>", "<C-\\><C-n>:ToggleTerm direction=float<CR>")
map("i", "<C-\\>", "<C-\\><C-n>:ToggleTerm direction=float<CR>")

-- Quit, Exit and Save
map("n", "<leader>qt", ":bd<CR>")
map("n", "<leader>qv", ":qa<CR>")
map("n", "<leader>q!", ":qa!<CR>")
map("n", "<leader>qw", ":wq<CR>")

-- Zen Mode
map("n", "<leader>z", ":Goyo<CR>")
