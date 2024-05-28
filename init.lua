local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Load general settings
require('generals')

-- Load plugins via lazy.nvim
require('plugins_lazy')

-- Conditional loading based on environment
if vim.g.vscode then
  -- VSCode extension
  require('keymaps')
else
  -- Ordinary Neovim
  require('config')
  require('lsp_config')
  require('formatter_config')
  require('cmp_config')
  require('snippet_config')
  require('keymaps')
  -- Other Configurations
  vim.g.perl_enabled = 1
  vim.o.wrap = true
  vim.o.breakindent = true
  vim.cmd [[colorscheme caret]]
end
