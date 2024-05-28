-- Asociar tipos de archivo a efm-langserver
vim.cmd [[
  au BufRead,BufNewFile *.html.erb set filetype=eruby
]]

vim.cmd [[
  au BufRead,BufNewFile *.yml set filetype=yaml
]]

require("mason").setup()
require("mason-lspconfig").setup()

local servers = { "pyright", "solargraph",  "bashls", "eslint", "tsserver", "emmet_ls", "lua_ls", "gopls" }
local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, server in ipairs(servers) do
	require("lspconfig")[server].setup({
		root_dir = function()
			return vim.fn.getcwd()
		end,
		capabilities = capabilities,
		on_attach = on_attach,
		flags = lsp_flags,
	})
end

-- Cargar los módulos necesarios
local null_ls = require("null-ls")

null_ls.setup({
    sources = {

        -- Formateador para archivos ERB
        null_ls.builtins.formatting.prettier.with({
            extra_args = { "--plugin=@prettier/plugin-ruby", "--parser", "html" },
            filetypes = { "eruby" }
        }),

        -- Linter para archivos ERB
        null_ls.builtins.diagnostics.rubocop.with({
            filetypes = { "eruby" }
        }),
    },
})


-- Trouble

require("trouble").setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
})

