local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	"eslint",
	"lua_ls",
	"sqlls",
	"tsserver",
})

lsp.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

lsp.configure("tsserver", {
	settings = {
		completions = {
			completeFunctionCalls = true,
		},
	},
})

lsp.setup()

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.formatting.stylua,
	},
})

require("mason-null-ls").setup({
	-- ensure_installed = nil,
	automatic_installation = true,
})

local cmp = require("cmp")
-- local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
	mapping = {
		-- `Enter` key to confirm completion
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = require("lspkind").cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
		}),
	},
})

require("lualine").setup({
	options = { theme = "solarized" },
})
