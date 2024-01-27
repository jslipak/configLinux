require("mason").setup()
require("mason-lspconfig").setup()

local servers = { "pyright", "solargraph", "ruby_ls", "bashls", "eslint", "tsserver", "emmet_ls", "lua_ls", "gopls" }
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

-- Trouble

require("trouble").setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
})
-- null-ls
local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

require("null-ls").setup({
	sources = {
		formatting.prettier,
		formatting.black,
		formatting.stylua,
		formatting.rubocop,
		formatting.erb_lint,
		formatting.gofmt,
		diagnostics.flake8,
	},
})

require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = true,
	automatic_setup = false,
})
