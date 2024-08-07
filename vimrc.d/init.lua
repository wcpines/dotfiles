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
    -- null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.rubocop,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.pg_format,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.formatting.black,
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
local cmp_action = require("lsp-zero").cmp_action()

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
  sections = {
    lualine_c = { { "filename", file_status = true, path = 3 } },
    lualine_x = { "filetype" },
  },
})

-- local ok_status, NeoSolarized = pcall(require, "NeoSolarized")

-- if not ok_status then
--   return
-- end

-- NeoSolarized.setup({
--   style = "dark",       -- "dark" or "light"
--   enable_italics = true, -- Italics for different hightlight groups (eg. Statement, Condition, Comment, Include, etc.)
--   styles = {
--     -- Style to be applied to different syntax groups
--     comments = { italic = true },
--     keywords = { italic = true },
--     functions = { bold = true },
--     variables = {},
--     string = { italic = true },
--     underline = true, -- true/false; for global underline
--     undercurl = true, -- true/false; for global undercurl
--   },
-- })

-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L308
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { "tsx", "typescript", "javascript", "bash", "vimdoc", "vim", "ruby", "elixir", "erlang" },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  highlight = { enable = false },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_decremental = "<BS>",
      node_incremental = "<CR>",
      -- scope_incremental = "<CR>",
      -- scope_deccremental = "<S-CR>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = false,
    },
  },
})

