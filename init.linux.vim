""" Optixal's Neovim Init.vim

""" Vim-Plug
call plug#begin()
Plug 'wbthomason/packer.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-journal'
Plug 'junegunn/rainbow_parentheses.vim'

" Aethetics - Additional

" Functionalities
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'preservim/tagbar'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-abolish'
Plug 'andrewradev/splitjoin.vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'andrewradev/switch.vim'
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/restore_view.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'alvan/vim-closetag'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'sheerun/vim-polyglot'
Plug 'chrisbra/Colorizer'
Plug 'vim-scripts/loremipsum'
Plug 'dkarter/bullets.vim'
Plug 'sbdchd/neoformat'
Plug 'maksimr/vim-jsbeautify'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'mhinz/vim-signify'
Plug 'kien/ctrlp.vim'
Plug 'f-person/git-blame.nvim'
Plug 'https://github.com/adelarsq/vim-matchit'
Plug 'kana/vim-textobj-user'

"" Formater 
Plug 'dense-analysis/ale'
Plug 'splattael/rufo-vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" Javascript plug-in
Plug 'pangloss/vim-javascript'
"" Python Plug-in
Plug 'nvie/vim-flake8'
Plug 'psf/black'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
" Color Scheme
Plug 'yuttie/hydrangea-vim'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'rhysd/vim-color-spring-night'
Plug 'wadackel/vim-dogrun'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
Plug 'jacoborus/tender.vim'
Plug 'morhetz/gruvbox'
Plug 'franbach/miramare'
Plug 'pgavlin/pulumi.vim'
Plug 'arzg/vim-colors-xcode'
Plug 'NLKNguyen/papercolor-theme'
Plug 'arcticicestudio/nord-vim'
Plug 'EdenEast/nightfox.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'rakr/vim-one'
Plug 'ayu-theme/ayu-vim' " or other package manager
Plug 'relastle/bluewery.vim'
Plug 'gilgigilgil/anderson.vim'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'mangeshrex/uwu.vim'
Plug 'junegunn/seoul256.vim'
" CoC Use release branch (Recommend)
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }
" Ruby
Plug 'vim-ruby/vim-ruby' " For Facts, Ruby functions, and custom providers
Plug 'kurtpreston/vim-autoformat-rails'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-endwise'
Plug 'ngmy/vim-rubocop'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-bundler'
Plug 'janko-m/vim-test'
Plug 'gmarik/Vundle.vim'
Plug 'slim-template/vim-slim'
Plug 'metakirby5/codi.vim'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-rvm'
"Backet Color
Plug 'luochen1990/rainbow'
"Docset
Plug 'heavenshell/vim-pydocstring'
Plug 'sunaku/vim-dasht'
call plug#end()

"""Lua Setup Core plugin, configuration (lua)
lua require('generals')
lua require('plugins')
lua require('line_themes/dharmx_theme') 
lua require('config')
lua require('keymaps')

""" Plugin Configurations
call nvim_input('<tab>')

" coc config
let g:coc_global_extensions = [
\ 'coc-solargraph',
\ 'coc-diagnostic',
\ 'coc-css',
\ 'coc-yaml',
\ 'coc-snippets',
\ 'coc-pairs',
\ 'coc-tsserver',
\ 'coc-eslint', 
\ 'coc-prettier', 
\ 'coc-json', 
\]

""" Python3 VirtunlEnv
let g:python3_host_prog='/bin/python'
let g:python_host_prog='/bin/python'


"Copilot 
let g:copilot_no_tab_map = v:true
let g:copilot_filetypes = {
\ '*': v:false,
\ }
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <C-Space> coc#select()
imap <silent><script><expr> <M-j> copilot#Accept("\<CR>")


"Codi
let g:codi#virtual_text = 0
let g:codi#width = 20
let g:codi#rightsplit = 0
let g:codi#rightalign = 0
" Comment in the same buffer
" let g:codi#virtual_text_prefix = '🎯➔'
" let g:codi#virtual_text_pos = 60

"Git Blame
let g:gitblame_enabled = 1

"" Neovim :Terminal
tmap <Esc> <C-\><C-n>
tmap <C-w> <Esc><C-w>
"tmap <C-d> <Esc>:q<CR>
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

"indentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

" TagBar
let g:tagbar_width = 30
let g:tagbar_iconchars = ['↠', '↡']

" fzf-vim
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'Type'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Character'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.5, 'highlight': 'Comment' } }
let $FZF_DEFAULT_OPTS='--reverse'

""" ALE
let g:ale_linters = {
      \   'ruby': ['standardrb', 'rubocop'],
      \   'python': ['flake8', 'pylint'],
      \   'javascript': ['eslint'],
      \}

let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\    'ruby': ['standardrb'],
\}

let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma all'


""" Toggle spellchecking
function! ToggleSpellCheck()
  set spell!
  if &spell
    echo "Spellcheck ON"
  else
    echo "Spellcheck OFF"
  endif
endfunction

""" Other Configurations
let g:perl_enabled = 1
set wrap breakindent


"Shorcuts for insert and visual mode 
:imap \nn <C-O>o
:imap \NN <C-O>O
:imap \cl  <C-o>:noh<CR>




"Bufer and motion
nmap <leader>z :Goyo<CR>

"Copilot

"Docsets
nmap <leader>d <Plug>(pydocstring)
nmap <Leader>k :Dasht<Space>
nmap <Leader><Leader>k :Dasht!<Space>
nnoremap <silent> <Leader>K :call Dasht(dasht#cursor_search_terms())<Return>
nnoremap <silent> <Leader><Leader>K :call Dasht(dasht#cursor_search_terms(), '!')<Return>
vnoremap <silent> <Leader>K y:<C-U>call Dasht(getreg(0))<Return>
vnoremap <silent> <Leader><Leader>K y:<C-U>call Dasht(getreg(0), '!')<Return>
"Telescope
nmap <leader>tel :Telescope <CR>
nmap <leader>tF :Telescope live_grep<CR>
nmap <leader>tf :Telescope fd<CR>
nmap <leader>th :Telescope help_tags<CR>
nmap <leader>tH :Telescope man_pages<CR>
nmap <leader>tc :Telescope commands<CR>
nmap <leader>ta :Telescope autocommands<CR>
nmap <leader>tz :Telescope spell_suggest<CR>

"Register
"Call :Registers
"Press " in normal or visual mode
"Press CtrlR in insert mode

"splitjoin in normal mode silent
" gS to split a one-liner into multiple lines
" gJ (with the cursor on the first line of a block) to join a block into a single-line statement.
" gs switch true false

"Marks
" mx              Set mark x
"    m,              Set the next available alphabetical (lowercase) mark
"    m;              Toggle the next available mark at the current line
"    dmx             Delete mark x
"    dm-             Delete all marks on the current line
"    dm<space>       Delete all marks in the current buffer
"    m]              Move to next mark
"    m[              Move to previous mark
"    m:              Preview mark. This will prompt you for a specific mark to
"                    preview; press <cr> to preview the next mark.
"                    
"    m[0-9]          Add a bookmark from bookmark group[0-9].
"    dm[0-9]         Delete all bookmarks from bookmark group[0-9].
"    m}              Move to the next bookmark having the same type as the bookmark under
"                    the cursor. Works across buffers.
"    m{              Move to the previous bookmark having the same type as the bookmark under
"                    the cursor. Works across buffers.
"    dm=             Delete the bookmark under the cursor.

" NvimTree
" g? get all helps when it's open

" COMMENT 
" Normal Mode
" `gco` - Insert comment to the next line and enters INSERT mode
" `gcO` - Insert comment to the previous line and enters INSERT mode
" `gcA` - Insert comment to end of the current line and enters INSERT mode
" Visual Mode
" `gc` - Toggles the region using linewise comment
" `gb` - Toggles the region using blockwise comment
" " NORMAL mode
" `gco` - Insert comment to the next line and enters INSERT mode
" `gcO` - Insert comment to the previous line and enters INSERT mode
" `gcA` - Insert comment to end of the current line and enters INSERT mode
" Examples
" # Linewise
"
" `gcw` - Toggle from the current cursor position to the next word
" `gc$` - Toggle from the current cursor position to the end of line
" `gc}` - Toggle until the next blank line
" `gc5j` - Toggle 5 lines after the current cursor position
" `gc8k` - Toggle 8 lines before the current cursor position
" `gcip` - Toggle inside of paragraph
" `gca}` - Toggle around curly brackets
"
" # Blockwise
"
" `gb2}` - Toggle until the 2 next blank line
" `gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
" `gbac` - Toggle comment around a class (w/ LSP/treesitter support)

