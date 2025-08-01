--------------------------
-------SETUP Colors-------
--------------------------

-- Declare globals for LSP
---@diagnostic disable: undefined-global
local vim = vim

-- Configure split borders for better visibility
vim.opt.fillchars = {
	horiz = "━",
	horizup = "┻",
	horizdown = "┳",
	vert = "┃",
	vertleft = "┫",
	vertright = "┣",
	verthoriz = "╋",
}

-- Set plain black borders for splits
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#000000", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#000000", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#000000", bg = "NONE" })

-- Setup NeoSolarized colorscheme
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

-- Check if required plugins are available
local function check_plugin(plugin_name)
	local ok, _ = pcall(require, plugin_name)
	if not ok then
		vim.api.nvim_err_writeln(string.format("Plugin '%s' not found. Please run :PlugInstall", plugin_name))
		return false
	end
	return true
end

-- Check all required plugins
local required_plugins = {
	"mason",
	"mason-lspconfig",
	"lspconfig",
	"cmp_nvim_lsp",
	"null-ls",
	"conform",
	"cmp",
	"lspkind",
}

for _, plugin in ipairs(required_plugins) do
	if not check_plugin(plugin) then
		return
	end
end

-- LSP keymaps
local function lsp_attach(client, bufnr)
	-- Buffer local mappings
	local opts = { buffer = bufnr, noremap = true, silent = true }

	-- LSP keymaps
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics in a floating window" })
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
end

-- Setup Mason
require("mason").setup({
	ui = {
		border = "rounded",
	},
})

-- Setup Mason LSP Config
require("mason-lspconfig").setup({
	ensure_installed = { "ts_ls", "elixirls", "sqlls", "lua_ls" },
	automatic_enable = true,
})

-- LSP capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup LSP servers
local lspconfig = require("lspconfig")

-- TypeScript/JavaScript (using ts_ls instead of deprecated tsserver)
lspconfig.ts_ls.setup({
	on_attach = lsp_attach,
	capabilities = capabilities,
	cmd = { "typescript-language-server", "--stdio" },
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
})

-- Elixir
lspconfig.elixirls.setup({
	on_attach = lsp_attach,
	capabilities = capabilities,
	cmd = { "elixir-ls" },
	settings = {
		elixirLS = {
			-- Add any Elixir-specific settings here
		},
	},
})

-- SQL
lspconfig.sqlls.setup({
	on_attach = lsp_attach,
	capabilities = capabilities,
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	settings = {
		sqlls = {
			-- Add any SQL-specific settings here
		},
	},
})

-- Lua
lspconfig.lua_ls.setup({
	on_attach = lsp_attach,
	capabilities = capabilities,
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Setup null-ls for diagnostics and formatting
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

-- Setup conform for formatting
require("conform").setup({
	formatters_by_ft = {
		["*"] = { "codespell" },
		["_"] = { "trim_whitespace" },
		elixir = { "mix" },
		graphql = { "prettier" },
		helm = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		json = { "jq_format", "prettier" },
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

-- Key mapping for manual formatting
vim.api.nvim_set_keymap(
	"n",
	"<leader>M",
	'<cmd>lua require("conform").format({async = true})<CR>',
	{ noremap = true, silent = true }
)

-- Setup completion
local cmp = require("cmp")

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
			mode = "symbol",
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
	mapping = cmp.mapping.preset.insert({
		-- Navigate between completion items
		["<Tab>"] = cmp.mapping.select_next_item({ behavior = "select" }),
		["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = "select" }),

		-- `Enter` key to confirm completion
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		-- Ctrl+Space to trigger completion menu
		["<S-Space>"] = cmp.mapping.complete(),

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
	options = {
		theme = "NeoSolarized",
	},
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

-- Setup Claude Code
require("claude-code").setup({
	-- Terminal window settings
	window = {
		split_ratio = 0.3, -- Percentage of screen for the terminal window
		position = "botright", -- Position of the window
		enter_insert = true, -- Enter insert mode when opening Claude Code
		hide_numbers = true, -- Hide line numbers in the terminal window
		hide_signcolumn = true, -- Hide the sign column in the terminal window
	},
	-- File refresh settings
	refresh = {
		enable = true, -- Enable file change detection
		updatetime = 100, -- updatetime when Claude Code is active
		timer_interval = 1000, -- How often to check for file changes
		show_notifications = true, -- Show notification when files are reloaded
	},
	-- Git project settings
	git = {
		use_git_root = true, -- Set CWD to git root when opening Claude Code
	},
	-- Shell-specific settings
	shell = {
		separator = "&&", -- Command separator for bash
		pushd_cmd = "pushd", -- Command to push directory onto stack
		popd_cmd = "popd", -- Command to pop directory from stack
	},
	-- Command settings
	command = "claude", -- Command used to launch Claude Code
	-- Command variants
	command_variants = {
		continue = "--continue", -- Resume the most recent conversation
		resume = "--resume", -- Display an interactive conversation picker
		verbose = "--verbose", -- Enable verbose logging
	},
	-- Keymaps
	keymaps = {
		toggle = {
			normal = "<leader>cc", -- Normal mode keymap for toggling Claude Code
			terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code
			variants = {
				continue = "<leader>cC", -- Continue conversation
				verbose = "<leader>cV", -- Verbose mode
			},
		},
		window_navigation = true, -- Enable window navigation keymaps
		scrolling = true, -- Enable scrolling keymaps
	},
})

-- Load plugin configurations
local plugin_configs = dofile("/Users/colby/dotfiles/vimrc.d/plugin_configs.lua")
plugin_configs.init()
