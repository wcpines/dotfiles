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
		config = function()
			local elixir = require("elixir")

			elixir.setup({
				nextls = {
					enable = true,
					on_attach = function(client, bufnr)
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
					additional_vim_regex_highlighting = true,
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
	{
		"greggh/claude-code.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for git operations
		},
		config = function()
			require("claude-code").setup({
				-- Terminal window settings
				window = {
					split_ratio = 0.3, -- Percentage of screen for the terminal window
					position = "botright", -- Position: "botright", "topleft", "vertical", "float"
					enter_insert = true, -- Enter insert mode when opening Claude Code
					hide_numbers = true, -- Hide line numbers in the terminal window
					hide_signcolumn = true, -- Hide the sign column in the terminal window
				},
				-- File refresh settings
				refresh = {
					enable = true, -- Enable file change detection
					updatetime = 100, -- updatetime when Claude Code is active (milliseconds)
					timer_interval = 1000, -- How often to check for file changes (milliseconds)
					show_notifications = true, -- Show notification when files are reloaded
				},
				-- Git project settings
				git = {
					use_git_root = true, -- Set CWD to git root when opening Claude Code
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
						normal = "<C-,>", -- Normal mode keymap for toggling Claude Code
						terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code
						variants = {
							continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
							verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
						},
					},
					window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
					scrolling = true, -- Enable scrolling keymaps (<C-f/b>)
				},
			})
		end,
	},

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
})
