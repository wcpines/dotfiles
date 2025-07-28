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
	{ "chrisbra/csv.vim", ft = { "tsv", "csv" } },
	{ "darfink/vim-plist", ft = "plist" },
	{ "elixir-tools/elixir-tools.nvim" },
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
	{ "greggh/claude-code.nvim" },

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
	{ "junegunn/fzf.vim" },
	{ "mhinz/vim-grepper" },
	{ "subnut/visualstar.vim" },
	{ "Dkendal/nvim-alternate" },

	-- Display
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "nvim-lualine/lualine.nvim" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "folke/tokyonight.nvim" },
	{ "rebelot/kanagawa.nvim" },
	{ "calind/selenized.nvim" },
	{ "craftzdog/solarized-osaka.nvim" },
	{
		"Tsuzat/NeoSolarized.nvim",
		branch = "master",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme NeoSolarized]])
		end,
	},
	{ "elixir-editors/vim-elixir" },
	{ "vim-scripts/AnsiEsc.vim" },
	{ "vim-scripts/restore_view.vim" },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			-- Define subtle highlight groups for indent lines using NeoSolarized colors
			vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#073642", nocombine = true })
			vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#073642", nocombine = true })
			vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg = "#073642", nocombine = true })
			vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg = "#073642", nocombine = true })
			vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg = "#073642", nocombine = true })
			vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { fg = "#073642", nocombine = true })

			-- Configure indent-blankline
			require("ibl").setup({
				indent = {
					char = "│",
					tab_char = "│",
					highlight = "IndentBlanklineIndent1",
				},
				scope = {
					enabled = true,
					show_start = true,
					show_end = true,
					injected_languages = true,
					highlight = "Function",
					priority = 500,
				},
				exclude = {
					filetypes = {
						"help",
						"startify",
						"dashboard",
						"lazy",
						"mason",
						"notify",
						"toggleterm",
						"lspinfo",
						"checkhealth",
						"man",
					},
					buftypes = { "terminal", "nofile", "prompt", "toggleterm" },
				},
			})
		end,
	},

	-- Misc Enhancements
	{ "AndrewRadev/splitjoin.vim" },
	{
		"andymass/vim-matchup",
		init = function()
			vim.g.matchup_treesitter_enabled = 1
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
