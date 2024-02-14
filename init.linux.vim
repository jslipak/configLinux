"" Vim-Plug
call plug#begin()
Plug 'wbthomason/packer.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-journal'
Plug 'junegunn/rainbow_parentheses.vim'

" Aethetics - Additional

" Functionalities
Plug 'tpope/vim-sensible'
Plug 'preservim/tagbar'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'andrewradev/splitjoin.vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'andrewradev/switch.vim'
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/restore_view.vim'
" Plug 'jiangmiao/auto-pairs'
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
Plug 'terryma/vim-multiple-cursors'
Plug 'kien/ctrlp.vim'
Plug 'https://github.com/adelarsq/vim-matchit'
Plug 'kana/vim-textobj-user'
Plug 'luochen1990/rainbow'
Plug 'heavenshell/vim-pydocstring'
Plug 'sunaku/vim-dasht'

call plug#end()

"" Setup Core plugin, configuration (lua)

lua require('generals')
lua require('plugins')


if exists('g:vscode')
" VSCode extension
  lua require('keymaps')
else
  " ordinary Neovim
  lua require('line_themes/dharmx_theme')
  lua require('config')
  lua require('lsp_config')
  lua require('cmp_config')
  lua require('snippet_config')
  lua require('keymaps')
  "" Python3 VirtunlEnv
  let g:python3_host_prog='/bin/python'
  let g:python_host_prog='/bin/python'

  "Codi
  let g:codi#virtual_text = 0
  let g:codi#width = 20
  let g:codi#rightsplit = 0
  let g:codi#rightalign = 0
  " Comment in the same buffer
  " let g:codi#virtual_text_prefix = '🎯➔'
  " let g:codi#virtual_text_pos = 60

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
  \ { 'fg': ['fg', 'Normal'],
  \ 'bg': ['bg', 'Normal'],
  \ 'hl': ['fg', 'Comment'],
  \ 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+': ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+': ['fg', 'Statement'],
  \ 'info': ['fg', 'Type'],
  \ 'border': ['fg', 'Ignore'],
  \ 'prompt': ['fg', 'Character'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker': ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header': ['fg', 'Comment'] }
  let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.5, 'highlight': 'Comment' } }
  let $FZF_DEFAULT_OPTS='--reverse'

  "" Toggle spellchecking
  function! ToggleSpellCheck()
  set spell!
  if &spell
  echo "Spellcheck ON"
  else
  echo "Spellcheck OFF"
  endif
  endfunction

  "" Other Configurations
  let g:perl_enabled = 1
  set wrap breakindent
endif
