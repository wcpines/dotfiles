--------------------------
-------SETUP Colors-------
--------------------------

local ok_status, NeoSolarized = pcall(require, "NeoSolarized")

if not ok_status then
	vim.api.nvim_err_writeln("NeoSolarized not found. Please make sure it's installed.")
	return
end

-- Default Setting for NeoSolarized
NeoSolarized.setup({
	style = "dark", -- "dark" or "light"
	transparent = true, -- true/false; Enable this to disable setting the background color
	terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
	enable_italics = true, -- Italics for different highlight groups (eg. Statement, Condition, Comment, Include, etc.)
	styles = {
		-- Style to be applied to different syntax groups
		comments = { italic = true },
		keywords = { italic = true },
		functions = { bold = true },
		variables = {},
		string = { italic = true },
		underline = true, -- true/false; for global underline
		undercurl = true, -- true/false; for global undercurl
	},
	-- Add specific highlight groups
	on_highlights = function(highlights, colors)
		highlights.Include.fg = colors.red -- Using `red` foreground for Includes
	end,
})

-- Function to get the current ITERM_PROFILE
local function get_iterm_profile()
	-- Force Vim to re-read the environment variable
	vim.fn.system("echo $ITERM_PROFILE > /tmp/iterm_profile")
	local handle = io.open("/tmp/iterm_profile", "r")
	if handle == nil then
		vim.api.nvim_err_writeln("Failed to read ITERM_PROFILE")
		return nil
	end

	local result = handle:read("*a")
	handle:close()

	result = vim.trim(result)

	if result == "" then
		vim.api.nvim_echo({ { "\nITERM_PROFILE is empty", "WarningMsg" } }, true, {})
		return nil
	end

	-- vim.api.nvim_echo({ { "\nCurrent ITERM_PROFILE: " .. result, "None" } }, true, {})
	return result
end

-- Function to set colorscheme based on ITERM_PROFILE
local function set_colorscheme()
	local profile = get_iterm_profile()
	if profile == nil then
		vim.api.nvim_echo({ { "\nUsing default NeoSolarized settings", "WarningMsg" } }, true, {})
		return
	end

	if profile == "solarized-light" then
		vim.cmd([[colorscheme NeoSolarized]])
		vim.opt.background = "light"
	elseif profile == "solarized-dark" then
		vim.cmd([[colorscheme NeoSolarized]])
		vim.opt.background = "dark"
	elseif profile == "kanagawa" then
		vim.cmd("colorscheme kanagawa-wave")
	else
		vim.api.nvim_echo(
			{ { "\nUnrecognized ITERM_PROFILE: " .. profile .. ". Using default background.", "WarningMsg" } },
			true,
			{}
		)
		vim.cmd([[colorscheme NeoSolarized]])
	end
end

-- Autocommand to update colorscheme when entering a buffer or regaining focus
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	pattern = "*",
	callback = function()
		set_colorscheme()
	end,
})

-- Optional: Command to manually update the colorscheme
vim.api.nvim_create_user_command("UpdateColorScheme", set_colorscheme, {})
---------------------------
---------SETUP LSP---------
---------------------------
local lsp_zero = require("lsp-zero")

local lsp_attach = function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics in a floating window" })
	vim.keymap.set(
		"n",
		"<leader>C",
		vim.lsp.buf.code_action,
		{ noremap = true, silent = true, desc = "LSP code action" }
	)

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
		json = { "jq_format", "prettier" }, -- Add jq_format here
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
		jq_format = {
			command = "jq",
			args = { "." },
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
		{
			name = "buffer",
			keyword_length = 3,
			max_item_count = 10,
			option = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
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
		vim.diagnostic.enable()
		print("Diagnostics enabled")
	else
		vim.diagnostic.disable()
		print("Diagnostics disabled")
	end
end

-- Add this mapping to your keybindings section
vim.keymap.set("n", "<leader>D", function()
	toggle_diagnostics()
	require("cmp").setup.buffer({ enabled = false })
end, { desc = "Toggle diagnostics and disable completion" })

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
		disable = { "elixir", "csv" },

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = true,
	},
})

-- Get the nvim-alternate module once
local alternate = require("nvim-alternate")

-- Setup nvim-alternate with your pairs
alternate.setup({
	pairs = {
		-- Simple pairs (source and test)
		{ "lua/*.lua", "tests/*_spec.lua" },
		-- Example for specific file types
		{ "src/components/*.tsx", "src/components/*.test.tsx" },
		{ "src/lib/*.ts", "tests/lib/*.test.ts" },
		{ "lib/*.ex", "test/*_test.exs" },
		{ "lib/*/live/*.ex", "lib/*/live/*.html.heex" },
		{ "apps/*/lib/*.ex", "apps/*/test/*_test.exs" },
	},
})

-- Create Vim commands A and AV similar to vim-projectionist
vim.api.nvim_create_user_command("A", function()
	-- Edit the alternate file in the current window
	alternate.plug.edit()
end, {})

vim.api.nvim_create_user_command("AV", function()
	-- Open the alternate file in a vertical split
	vim.cmd("vsplit")
	alternate.plug.edit()
end, {})

-- Optional: Add more commands for different split types
vim.api.nvim_create_user_command("AS", function()
	-- Open the alternate file in a horizontal split
	vim.cmd("split")
	alternate.plug.edit()
end, {})

vim.api.nvim_create_user_command("AT", function()
	-- Open the alternate file in a new tab
	vim.cmd("tabnew")
	alternate.plug.edit()
end, {})
