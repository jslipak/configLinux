local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
-- Every unspecified option will be set to the default.
require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if ls.choice_active() then
        return "<Plug>luasnip-next-choice"
    else
        return "<Tab>"
    end
end, {
    expr = true,
})


ls.add_snippets("javascript", {
	s(
		"stictrl",
		fmt(
			[[
import {{ Controller }} from "@hotwired/stimulus"

// Connects to data-controller="{}"
export default class extends Controller {{
  connect() {{
    {}
  }}
}}
                ]],
			{
				i(1, "controller_name"),
				i(2, "body"),
			}
		)
	),
})

require("luasnip.loaders.from_vscode").lazy_load { paths = { "~/configLinux/snippetFolder/" } }
