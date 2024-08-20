local lsp_zero = require("lsp-zero")

local lsp_attach = function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics in a floating window" })

	-- Disable semantic highlights
	-- client.server_capabilities.semanticTokensProvider = nil
end

lsp_zero.extend_lspconfig({
	sign_text = {
		error = "✘",
		warn = "▲",
		hint = "⚑",
		info = "»",
	},
	lsp_attach = lsp_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

require("mason").setup({})

require("mason-lspconfig").setup({
	ensure_installed = { "tsserver", "elixirls", "sqlls", "lua_ls" },
	handlers = {
		lsp_zero.default_setup,
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
})

require("lspconfig").lua_ls.setup({
	on_init = function(client)
		lsp_zero.nvim_lua_settings(client, {})
	end,
})

require("lspconfig").sqlls.setup({
	on_attach = lsp_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		sqlls = {
			-- You can add any specific settings for sqlls here
		},
	},
})

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- diagnostics
		null_ls.builtins.diagnostics.codespell,
		null_ls.builtins.diagnostics.credo,
		null_ls.builtins.diagnostics.rubocop,
		null_ls.builtins.diagnostics.yamllint,
	},
})

require("conform").setup({
	formatters_by_ft = {
		["*"] = { "codespell" },
		["_"] = { "trim_whitespace" },
		elixir = { "mix" },
		graphql = { "prettier" },
		helm = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		json = { "prettier" },
		python = { "black" },
		rspec = { "rubocop" },
		ruby = { "rubocop" },
		rust = { "rustfmt" },
		scss = { "prettier" },
		lua = { "stylua" },
		sh = { "shfmt" },
		sql = { "pg_format" },
		typescript = { "prettier" },
		xml = { "xmllint" },
		yaml = { "prettier" },
		yml = { "prettier" },
	},
	formatters = {
		pg_format = {
			args = { "--comma-end", "--keyword-case", "2", "--function-case", "2", "--spaces", "2" },
		},
	},
	fallback_formatters = {
		lsp = true,
	},
})

-- -- Optional: Automatically format on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     require("conform").format({ async = false, lsp_fallback = true })
--   end,
-- })

-- Key mapping for manual formatting
vim.api.nvim_set_keymap(
	"n",
	"<leader>M",
	'<cmd>lua require("conform").format({async = true})<CR>',
	{ noremap = true, silent = true }
)

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
	},
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = require("lspkind").cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
		}),
	},
	mapping = cmp.mapping.preset.insert({
		-- Navigate between completion items
		["<Tab>"] = cmp_action.tab_complete(),
		["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = "select" }),

		-- `Enter` key to confirm completion
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		-- Ctrl+Space to trigger completion menu
		["<S-Space>"] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		["<C-f>"] = cmp_action.vim_snippet_jump_forward(),
		["<C-b>"] = cmp_action.vim_snippet_jump_backward(),

		-- Scroll up and down in the completion documentation
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
	}),
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
})

require("lualine").setup({
	sections = {
		lualine_c = { { "filename", file_status = true, path = 3 } },
		lualine_x = { "filetype" },
	},
})

-- Function to toggle diagnostics
local diagnostics_active = true
local function toggle_diagnostics()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
		print("Diagnostics enabled")
	else
		vim.diagnostic.hide()
		print("Diagnostics disabled")
	end
end

-- Add this mapping to your keybindings section
vim.keymap.set("n", "<leader>D", toggle_diagnostics, { desc = "Toggle diagnostics" })

require("nvim-treesitter.configs").setup({
	-- A directory to install the parsers into.
	-- If this is excluded or nil parsers are installed
	-- to either the package dir, or the "site" dir.
	-- If a custom path is used (not nil) it must be added to the runtimepath.
	-- parser_install_dir = "/some/path/to/store/parsers",

	-- A list of parser names, or "all"
	ensure_installed = { "typescript", "elixir", "lua", "python", "sql" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = false,

	-- List of parsers to ignore installing (for "all")
	ignore_install = { "javascript" },

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- list of language that will be disabled
		disable = {"elixir", "csv"},

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = true,
	},
})
