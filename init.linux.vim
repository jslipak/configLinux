""" Optixal's Neovim Init.vim

""" Vim-Plug
call plug#begin()

" Aesthetics - Main
Plug 'dracula/vim', { 'commit': '147f389f4275cec4ef43ebc25e2011c57b45cc00' }
if !exists('g:started_by_firenvim')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
endif
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-journal'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'zaki/zazen'
Plug 'tpope/vim-ragtag'

" Aethetics - Additional
Plug 'yuttie/hydrangea-vim'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'rhysd/vim-color-spring-night'

" Functionalities
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'preservim/tagbar'
Plug 'preservim/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/restore_view.vim'
"Plug 'davidhalter/jedi-vim'
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-abolish'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'sheerun/vim-polyglot'
Plug 'chrisbra/Colorizer'
Plug 'heavenshell/vim-pydocstring'
Plug 'vim-scripts/loremipsum'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'metakirby5/codi.vim'
Plug 'dkarter/bullets.vim'
Plug 'mattn/emmet-vim'
Plug 'sbdchd/neoformat'
Plug 'maksimr/vim-jsbeautify'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/RltvNmbr.vim'
Plug 'easymotion/vim-easymotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'terryma/vim-multiple-cursors'
Plug 'mhinz/vim-signify'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
" or                                , { 'branch': '0.1.x' }
" Formater 
Plug 'dense-analysis/ale'
Plug 'splattael/rufo-vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'kurtpreston/vim-autoformat-rails'
Plug 'tpope/vim-rails'
" Javascript plug-in
Plug 'pangloss/vim-javascript'
"" Python Plug-in
Plug 'nvie/vim-flake8'
Plug 'psf/black'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
" Chrome enxtension
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
"" "Markdown
Plug 'iamcco/markdown-preview.nvim' 
"" React 
Plug 'mxw/vim-jsx'
Plug 'mlaursen/vim-react-snippets'
" Entertainment
"Plug 'ryanss/vim-hackernews'
" Color Scheme
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
" CoC Use release branch (Recommend)
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }
Plug 'vim-ruby/vim-ruby' " For Facts, Ruby functions, and custom providers
Plug 'kien/ctrlp.vim'
"Backet Color
Plug 'luochen1990/rainbow'
"Blockchain
Plug 'tomlion/vim-solidity'
"Docset
Plug 'sunaku/vim-dasht'
call plug#end()

""" Plugin Configurations
" EMMET CONFIG
let g:user_emmet_leader_key=','
let g:user_emmet_settings = {
\  'html': {
\    'snippets': {
\      'html:5': '!!!+html>(head>(meta[charset=${charset}]+meta[name="viewport" content="width=device-width,initial-scale=1.0"]+meta[http-equiv="X-UA-Compatible" content="ie=edge"]+title +body'
    \}
	\} 
\}

" coc config
let g:coc_global_extensions = [
\ 'coc-snippets',
\ 'coc-pairs',
\ 'coc-tsserver',
\ 'coc-eslint', 
\ 'coc-prettier', 
\ 'coc-json', 
\ 'coc-solargraph',
\]


"RainbowParentheses
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
""" Python3 VirtunlEnv
let g:python3_host_prog='/bin/python'
let g:python_host_prog='/bin/python'

""" Coloring
syntax on
color dracula
highlight Pmenu guibg=white guifg=black gui=bold
highlight Comment gui=bold
highlight Normal gui=none
highlight NonText guibg=none

" Opaque Background (Comment out to use terminal's profile)
set termguicolors

" Transparent Background (For i3 and compton)
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE

"Copilot 
let g:copilot_no_tab_map = v:true

" NERDTree
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '↠'
let g:NERDTreeDirArrowCollapsible = '↡'
let NERDTreeQuitOnOpen = 1
let g:NERDTreeWinPos = "right"

" Airline
let g:airline_powerline_fonts = 1
let g:airline_section_z = ' %{strftime("%-I:%M %p")}'
let g:airline_section_warning = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
au User AirlineAfterInit  :let g:airline_section_z = airline#section#create(['windowswap', 'obsession', '%3p%%', 'maxlinenr', '->%3v'])

"" Neovim :Terminal
tmap <Esc> <C-\><C-n>
tmap <C-w> <Esc><C-w>
"tmap <C-d> <Esc>:q<CR>
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

" Disable documentation window
set completeopt=preview

" Supertab
let g:SuperTabDefaultCompletionType = "<C-n>"

" Ultisnips
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<C-x>"

" indentLine
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
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\}

let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma all'
""" Filetype-Specific Configurations

" HTML, XML, Jinja
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango inoremap {{ {{  }}<left><left><left>
autocmd FileType htmldjango inoremap {% {%  %}<left><left><left>
autocmd FileType htmldjango inoremap {# {#  #}<left><left><left>

" Markdown and Journal
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType journal setlocal shiftwidth=2 tabstop=2 softtabstop=2

" foldings

"" Custom Functions

" Dracula Mode (Dark)
function! ColorDracula()
    let g:airline_theme=''
    color dracula
    IndentLinesEnable
endfunction

" Seoul256 Mode (Dark & Light)
function! ColorSeoul256()
    let g:airline_theme='silver'
    color seoul256
    IndentLinesDisable
endfunction

" Zazen Mode (Black & White)
function! ColorZazen()
    let g:airline_theme='badcat'
    color zazen
    IndentLinesEnable
endfunction


""" Toggle spellchecking
function! ToggleSpellCheck()
  set spell!
  if &spell
    echo "Spellcheck ON"
  else
    echo "Spellcheck OFF"
  endif
endfunction

function! ToggleCopilot()
  if exists('b:copilot')
    unlet b:copilot
    :Copilot disable
    echo "Copilot OFF"
  else
    let b:copilot = 1
    :Copilot enable 
    echo "Copilot ON"
  endif
endfunction



if exists('g:started_by_firenvim') && g:started_by_firenvim
    " general options
    set laststatus=0 non
		let g:airline#extensions#tabline#enabled = 0
		let g:airline#extensions#fugitiveline#enabled = 0
    let g:airline_exclude_filetypes = [] " see source for current list
    augroup firenvim
        autocmd!
        autocmd BufEnter *.txt setlocal filetype=markdown.pandoc
    augroup END
endif

""" Other Configurations
:set mouse=a
:set scrolloff=8 " Start to scrolling down or up 8 lines before ord after
:colorscheme xcodedark
filetype plugin indent on
"   set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set ruler laststatus=2 showcmd showmode
set list listchars=trail:»,tab:»-
set fillchars+=vert:\ 
set wrap breakindent
set encoding=utf-8
set number
set title
set clipboard+=unnamedplus
set showmatch 
set cursorcolumn
set cursorline

""" Custom Mappings
let mapleader=" "
set pastetoggle=<F3>
nmap <F5> :call ToggleSpellCheck()<CR>
nmap <F6> :call ToggleCopilot()<CR>
nmap <F8> :TagbarToggle<CR>

"Files , Directories , Exit 
nmap <leader>f :Files<CR>
nmap <leader>q :bd<CR>
nmap <leader>Q :q<CR>
nmap <leader>\ :NERDTree<CR>
nmap <leader>F :Rg<CR>
nmap <C-s> :w<CR>
nmap <C-s> :w<CR>

"Setup Vim
nmap <leader>r :so ~/.config/nvim/init.vim<CR>
nmap <leader>R :tabnew ~/.config/nvim/init.vim<CR>
nmap gt :bnext<CR>
nmap gT :bprevious<CR>
nmap <leader>T <C-w>v<C-w>l:terminal<CR>
"Shorcuts for insert and visual mode 
:imap \nn <C-O>o
:imap \NN <C-O>O
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
imap <C-e> <ESC>A
imap <C-a> <ESC>I


" Config for coc.nvim
" Note previus and next origina keymap [c and ]c
nmap <silent> cp <Plug>(coc-diagnostic-prev) 
nmap <silent> cn <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
inoremap <silent><expr> <C-Space> coc#select()
xmap <silent>ca :CocAction<CR>
nmap <silent>ca :CocAction<CR>
nmap <silent>cf  <Plug>(coc-fix-current)

"Colors and utils Colorl 
nmap <leader>ee :Colors<CR>
nmap <leader>ea :AirlineTheme 
nmap <leader>e1 :call ColorDracula()<CR>
nmap <leader>e2 :call ColorSeoul256()<CR>
nmap <leader>e3 :call ColorZazen()<CR>
nmap <leader>h :RainbowParentheses!!<CR>

"Bufer and motion
nmap <leader>z :Goyo<CR>
nmap <C-j> <plug>(easymotion-bd-f)
imap <C-j> <ESC><plug>(easymotion-bd-f)
nmap <leader>n :set rnu!<CR>
nmap <C-l> :noh<CR>
imap <C-l>  <C-o>:noh<CR>i

"Git
nmap <leader>G :G<CR>
nmap <leader>gf :GFiles<CR>
nmap <leader>gd :Gdiffsplit<CR>
nmap <leader>gl :diffget //3<CR>
nmap <leader>gh :diffget //2<CR>
nmap <leader>gc :GCheckout<CR>
nmap <leader>gn <Plug>(GitGutterNextHunk)
nmap <leader>gp <Plug>(GitGutterPrevHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
nmap <leader>gw <Plug>(GitGutterPreviewHunk)

"Copilot
imap <silent><script><expr> <M-j> copilot#Accept("\<CR>")
imap <silent> <M-,> <Plug>(copilot-previous)
imap <silent> <M-.> <Plug>(copilot-next)
imap <silent> <M-;> <Plug>(copilot-suggest)

"Docsets
nmap <leader>d <Plug>(pydocstring)
nmap <Leader>k :Dasht<Space>
nmap <Leader><Leader>k :Dasht!<Space>
nnoremap <silent> <Leader>K :call Dasht(dasht#cursor_search_terms())<Return>
nnoremap <silent> <Leader><Leader>K :call Dasht(dasht#cursor_search_terms(), '!')<Return>
vnoremap <silent> <Leader>K y:<C-U>call Dasht(getreg(0))<Return>
vnoremap <silent> <Leader><Leader>K y:<C-U>call Dasht(getreg(0), '!')<Return>

"Telescop
nmap <leader>tp :Telescope<CR>
nmap <leader>tk :Telescope keymaps<CR>
nmap <leader>tp :Telescope <CR>
nmap <leader>tF :Telescope live_grep<CR>
nmap <leader>tf :Telescope fd<CR>
nmap <leader>tt :Telescope tags<CR>
nmap <leader>tr :Telescope registers<CR>
nmap <leader>th :Telescope help_tags<CR>
nmap <leader>tH :Telescope man_pages<CR>
nmap <leader>tb :Telescope buffers<CR>
nmap <leader>tc :Telescope commands<CR>
nmap <leader>tm :Telescope marks<CR>
nmap <leader>ta :Telescope autocommands<CR>
nmap <leader>tvo :Telescope vim_options<CR>
nmap <leader>tG :Telescope git_status<CR>
nmap <leader>tgs :Telescope git_stash<CR>
nmap <leader>tgb :Telescope git_branches<CR>
nmap <leader>tgc :Telescope git_commits<CR>
nmap <leader>tgcb :Telescope git_bcommits<CR>
nmap <leader>tgf :Telescope git_files<CR>
nmap <leader>tz :Telescope spell_suggest<CR>
nmap <leader>tj :Telescope jumplist<CR>

