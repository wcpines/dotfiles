-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
	-- Syntax, languages, & frameworks
	{ "chrisbra/csv.vim" },
	{ "darfink/vim-plist", ft = "plist" },
	{
		"elixir-tools/elixir-tools.nvim",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		ft = { "elixir", "eelixir", "heex", "surface" },
		config = function()
			local elixir = require("elixir")

			elixir.setup({
				nextls = {
					enable = true,
					-- Prevent multiple instances
					single_file_support = false,
					-- Add debugging and performance settings
					init_options = {
						experimental = {
							completions = {
								enable = false, -- Disable to reduce load
							},
						},
					},
					cmd_env = {
						-- Enable debug logging
						NEXTLS_LOG_LEVEL = "debug",
					},
					-- Prevent automatic restarts that could spawn multiple instances
					flags = {
						debounce_text_changes = 1000, -- Wait 1s before processing changes
						allow_incremental_sync = true,
					},
					on_attach = function(client, bufnr)
						-- Disable semantic tokens to reduce load
						client.server_capabilities.semanticTokensProvider = nil

						-- LSP keymaps
						local opts = { buffer = bufnr, noremap = true, silent = true }
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
						vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
						vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
						vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
						vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
						vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
						vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
						vim.keymap.set(
							"n",
							"gl",
							vim.diagnostic.open_float,
							{ desc = "Show diagnostics in a floating window" }
						)
						vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
						vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
						vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
					end,
				},
				elixirls = { enable = false },
				credo = { enable = false },
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{ "hashivim/vim-terraform" },
	{ "https://github.com/elkasztano/nushell-syntax-vim" },
	-- { "lmeijvogel/vim-yaml-helper", ft = "yaml" },
	-- { "neowit/vim-force.com" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "typescript", "elixir", "lua", "python", "sql", "bash" },
				sync_install = false,
				auto_install = true,
				ignore_install = { "javascript" },
				modules = {},
				highlight = {
					enable = true,
					disable = { "elixir", "csv" },
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "preservim/vim-markdown" },
	-- {
	--	"prettier/vim-prettier",
	--	build = "yarn install",
	--	ft = { "javascript", "typescript", "css", "less", "scss", "json", "graphql", "markdown", "vue", "yaml", "html" },
	-- },
	{ "vim-scripts/sql_iabbr.vim", ft = "sql" },
	{ "z0mbix/vim-shfmt", ft = { "sh", "Dockerfile", "nu" } },

	-- LSP
	-- { "MunifTanjim/prettier.nvim" },
	{ "folke/trouble.nvim" },
	{ "jay-babu/mason-null-ls.nvim" },
	{ "stevearc/conform.nvim" },
	{ "nvimtools/none-ls.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "nvim-lua/plenary.nvim" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },

	-- Autocompletion
	{ "onsails/lspkind.nvim" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/nvim-cmp" },
	{ "saadparwaiz1/cmp_luasnip" },

	-- Snippets
	{ "L3MON4D3/LuaSnip" },
	{ "rafamadriz/friendly-snippets" },

	-- Text objects - Fix dependency order
	{ "kana/vim-textobj-user" }, -- Load this first
	{ "andyl/vim-textobj-elixir", ft = { "elixir", "eelixir" }, dependencies = { "kana/vim-textobj-user" } },
	{ "bps/vim-textobj-python", ft = "python", dependencies = { "kana/vim-textobj-user" } },
	{ "coderifous/textobj-word-column.vim", dependencies = { "kana/vim-textobj-user" } },
	{ "kana/vim-textobj-function", dependencies = { "kana/vim-textobj-user" } },
	{ "michaeljsmith/vim-indent-object" },
	-- { "vim-scripts/Align" },

	-- Search & file nav
	-- { "airblade/vim-rooter" },
	{ "henrik/vim-indexed-search" },
	{
		"junegunn/fzf",
		build = function()
			vim.fn["fzf#install"]()
		end,
	},
	{ "ibhagwan/fzf-lua" },
	{ "mhinz/vim-grepper" },
	{
		"subnut/visualstar.vim",
		event = "VeryLazy",
		keys = {
			{ "*", "<Plug>(VisualstarSearch-*)", mode = "x" },
			{ "#", "<Plug>(VisualstarSearch-#)", mode = "x" },
		},
	},
	{ "Dkendal/nvim-alternate" },

	-- Display
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "nvim-lualine/lualine.nvim" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "folke/tokyonight.nvim" },
	{ "rebelot/kanagawa.nvim" },
	{ "calind/selenized.nvim" },
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
	},
	{
		"Tsuzat/NeoSolarized.nvim",
		branch = "master",
		lazy = false,
		priority = 1000,
	},
	{ "elixir-editors/vim-elixir" },
	{ "vim-scripts/AnsiEsc.vim" },
	{ "vim-scripts/restore_view.vim" },

	-- Misc Enhancements
	{ "AndrewRadev/splitjoin.vim" },
	{
		"andymass/vim-matchup",
		init = function()
			vim.g.matchup_treesitter_enabled = 1
			vim.g.matchup_matchparen_deferred = 1
			vim.g.matchup_matchparen_hi_surround_always = 1
			-- Enable matchup for Elixir file types
			vim.g.matchup_override_vimtex = 1
		end,
		config = function()
			-- Enable Elixir do..end matching
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "elixir", "eelixir" },
				callback = function()
					vim.b.match_words = table.concat({
						"\\<do\\>:\\<end\\>",
						"\\<def\\>:\\<end\\>",
						"\\<defp\\>:\\<end\\>",
						"\\<defmodule\\>:\\<end\\>",
						"\\<defprotocol\\>:\\<end\\>",
						"\\<defimpl\\>:\\<end\\>",
						"\\<case\\>:\\<end\\>",
						"\\<cond\\>:\\<end\\>",
						"\\<receive\\>:\\<end\\>",
						"\\<try\\>:\\<rescue\\>:\\<catch\\>:\\<after\\>:\\<end\\>",
						"\\<if\\>:\\<else\\>:\\<end\\>",
						"\\<unless\\>:\\<else\\>:\\<end\\>",
						"\\<with\\>:\\<else\\>:\\<end\\>",
						"\\<fn\\>:\\<end\\>",
						"\\<quote\\>:\\<end\\>",
						"\\<for\\>:\\<end\\>",
					}, ",")
				end,
			})
		end,
	},
	{ "dhruvasagar/vim-table-mode", ft = { "tsv", "csv", "sql" } },
	{ "godlygeek/tabular" },
	{ "junegunn/goyo.vim", ft = "markdown" },
	{ "mattn/webapi-vim" },
	{ "mcasper/vim-infer-debugger" },
	{ "mzlogin/vim-markdown-toc", ft = "markdown" },
	{ "pbrisbin/vim-mkdir" },
	{ "skywind3000/asyncrun.vim" },
	{ "tommcdo/vim-exchange" },
	{ "tpope/vim-abolish" },
	{ "tpope/vim-dadbod" },
	{ "tpope/vim-endwise" },
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-repeat" },
	{ "tpope/vim-rhubarb" },
	{ "tpope/vim-surround" },
	{ "tpope/vim-vinegar" },
	{ "troydm/zoomwintab.vim" },
	{ "tweekmonster/startuptime.vim" },
	{ "vim-test/vim-test" },
	{ "vimlab/split-term.vim" },
	{ "wellle/targets.vim" },

	-- AI Integration
	{
		"folke/snacks.nvim",
		keys = {
			-- Core pickers
			{ "<leader>e", function() require("snacks").explorer() end, desc = "Explorer" },
			{ "<leader>p", function() require("snacks").picker() end, desc = "Picker" },
			{ "<leader>D", function() require("snacks").picker.diagnostics() end, desc = "Diagnostics" },
			{ "<leader>m", function() require("snacks").picker.recent() end, desc = "Recent Files" },
			
			-- Replace fzf-lua mappings
			{ "<leader>;", function() require("snacks").picker.command_history() end, desc = "Command History" },
			{ "<leader>b", function() require("snacks").picker.buffers() end, desc = "Buffers" },
			{ "<leader>f", function() require("snacks").picker.files() end, desc = "Files" },
			{ "<leader>g", function() require("snacks").picker.git_files() end, desc = "Git Files" },
			{ "<leader>T", function() require("snacks").picker.lsp_symbols() end, desc = "LSP Symbols" },
			
			-- Search mappings  
			{ "gR", function() require("snacks").picker.grep_word() end, desc = "Grep Word", mode = { "n", "x" } },
			{ "gF", function() require("snacks").picker.files({ pattern = vim.fn.expand('<cword>') }) end, desc = "Find Files with Word" },
		},
	},
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>c", nil, desc = "Claude Code" },
			{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>cs",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
			},
			-- Diff management
			{ "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
})
