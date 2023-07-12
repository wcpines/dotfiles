local lsp = require("lsp-zero")

lsp.preset("recommended")

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
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.diagnostics.actionlint,
		null_ls.builtins.diagnostics.codespell,
		null_ls.builtins.diagnostics.credo,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.diagnostics.rubocop,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.formatting.pg_format,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.mix.with({
			extra_filetypes = { "eelixir", "heex" },
			args = { "format", "-" },
			extra_args = function(_params)
				local version_output = vim.fn.system("elixir -v")
				local minor_version = vim.fn.matchlist(version_output, "Elixir \\d.\\(\\d\\+\\)")[2]

				local extra_args = {}

				-- tells the formatter the filename for the code passed to it via stdin.
				-- This allows formatting heex files correctly. Only available for
				-- Elixir >= 1.14
				if tonumber(minor_version, 10) >= 14 then
					extra_args = { "--stdin-filename", "$FILENAME" }
				end

				return extra_args
			end,
		}),
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
			mode = "symbol",    -- show only symbol annotations
			maxwidth = 50,      -- prevent the popup from showing more than provided characters
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
		}),
	},
})

require("lualine").setup({
	options = { theme = "solarized" },
	sections = {
		lualine_c = { { "filename", file_status = true } },
		lualine_x = { "filetype" },
	},
})
