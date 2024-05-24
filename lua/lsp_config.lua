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

-- Trouble

require("trouble").setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
})

