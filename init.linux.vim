lua require('generals')
lua require('plugins_lazy')


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

  "
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
