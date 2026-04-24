# Expert LSP Not Working - Diagnosis

## Summary

There are **two independent problems** preventing `gd` (jump to definition) from working with Expert LSP for Elixir files.

---

## Problem 1: Expert crashes on startup due to exported bash functions

**Severity: Critical** - Expert never fully starts, so no LSP features work at all.

In `.expert/expert.log` (line 564-596), Expert crashes with:

```
(MatchError) no match of right hand side value: ["get_current_business_log | xargs rg $search_term"]
    (xp_expert 0.1.0-d909980) lib/expert/port.ex:75: anonymous fn/1 in XPExpert.Port.reset_env/2
```

Expert's `reset_env/2` function parses environment variables expecting `KEY=VALUE` format. But your shell has **exported bash functions** (`BASH_FUNC_*%%` variables) whose values are multi-line function bodies. Expert can't parse these and crashes.

You have ~20+ exported bash functions in your environment (from `bashrc.d/` or sourced scripts). The specific one crashing it is `get_current_business_log`, but any of them could trigger this.

### Fixes for Problem 1

**Option A: Set `env_variables` in the LSP config to filter the environment**

In `init.lua`, add explicit env filtering:

```lua
vim.lsp.config('expert', {
  cmd = { 'expert', '--stdio' },
  cmd_env = {
    -- Only pass clean PATH, filtering out BASH_FUNC_* vars
    PATH = vim.env.PATH,
  },
  root_markers = { 'mix.exs', '.git' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
})
```

**Option B: Stop exporting the functions**

Wherever these functions are defined (likely sourced from a file outside this dotfiles repo, or via `export -f`), remove the export. Functions are available in the current shell without being exported to child processes. Expert (as a child process) doesn't need them.

**Option C: Report the bug upstream**

This is arguably a bug in Expert - it should handle non-standard environment variables gracefully. Consider filing an issue with the Expert LSP project.

---

## Problem 2: `on_attach` is silently ignored by `vim.lsp.config`

**Severity: High** - Even if Expert starts, the `gd` keymap would never be bound for Elixir buffers.

In `init.lua` (lines 179-185):

```lua
vim.lsp.config('expert', {
  cmd = { 'expert', '--stdio' },
  root_markers = { 'mix.exs', '.git' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
  on_attach = lsp_attach,       -- IGNORED by vim.lsp.config
  capabilities = capabilities,  -- IGNORED by vim.lsp.config
})
```

The new `vim.lsp.config` / `vim.lsp.enable` API (Neovim 0.11+) does **not** support `on_attach` or `capabilities` as config keys. These are `nvim-lspconfig`-specific options. They are silently dropped.

Meanwhile, your other servers (`ts_ls`, `sqlls`, `lua_ls`) use `lspconfig.X.setup()` which *does* support these keys, so their keymaps work fine.

### Fixes for Problem 2

**Option A (Recommended): Use a global `LspAttach` autocommand**

Replace per-server `on_attach` with a single autocommand. Add this near the top of the LSP section in `init.lua`:

```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Disable semantic tokens for all servers
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end

    local opts = { buffer = args.buf, noremap = true, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
  end,
})
```

Then remove `on_attach = lsp_attach` from all `lspconfig.X.setup()` calls (it becomes redundant).

**Option B: Use lspconfig for Expert instead of `vim.lsp.config`**

```lua
lspconfig.expert.setup({
  on_attach = lsp_attach,
  capabilities = capabilities,
  cmd = { 'expert', '--stdio' },
  root_dir = lspconfig.util.root_pattern('mix.exs', '.git'),
  filetypes = { 'elixir', 'eelixir', 'heex' },
})
```

Remove the `vim.lsp.config` / `vim.lsp.enable` block. Note: this only works if `nvim-lspconfig` has a built-in config entry for `expert`.

---

## Additional Note: `automatic_enable` in mason-lspconfig

In `init.lua` line 143:

```lua
require("mason-lspconfig").setup({
  ensure_installed = { "ts_ls", "sqlls", "lua_ls", "expert" },
  automatic_enable = true,
})
```

`automatic_enable = true` tells mason-lspconfig to automatically configure and start servers. This may conflict with your manual `vim.lsp.config`/`vim.lsp.enable` for expert, potentially causing double-start attempts or unexpected behavior. If you go with Option A/B above for Problem 2, consider removing `"expert"` from `ensure_installed` (if mason doesn't manage expert's installation) or setting `automatic_enable = false` for expert specifically.

---

## Quick Fix Checklist

1. Fix the environment crash (Problem 1, Option A or B)
2. Fix the keymap binding (Problem 2, Option A recommended)
3. Verify with `:LspInfo` or `:lua vim.print(vim.lsp.get_clients())` that expert attaches to `.ex` files
4. Verify `gd` is mapped with `:nmap gd` while in an Elixir buffer
