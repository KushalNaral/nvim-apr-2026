# Neovim Config Refactor Notes

## What Changed

### Structure
- `init.lua` — now a 9-line bootstrap that loads `config.*` modules, then calls lazy
- `lua/config/options.lua` — all `vim.opt.*`, diagnostic config, folding settings
- `lua/config/keymaps.lua` — global keymaps (window nav, format, inlay hints, etc.)
- `lua/config/autocmds.lua` — yank highlight, close-with-q, auto-resize splits
- `lua/config/lazy.lua` — lazy bootstrap + setup with `{import='plugins'}` and `{import='plugins.lang'}`, `performance.rtp.disabled_plugins`

### Plugin files (all new)
| File | Contents |
|---|---|
| `lua/plugins/ui.lua` | tokyonight, which-key (with groups), mini.nvim (ai/surround/statusline), guess-indent |
| `lua/plugins/editor.lua` | telescope+ext, oil, gitsigns (with keymaps), todo-comments, flash.nvim, harpoon2, trouble.nvim, grug-far |
| `lua/plugins/coding.lua` | blink.cmp, nvim-autopairs, nvim-ts-autotag, nvim-ufo+promise-async |
| `lua/plugins/treesitter.lua` | nvim-treesitter (main branch) + treesitter-textobjects (main) |
| `lua/plugins/lsp.lua` | mason, mason-lspconfig, mason-tool-installer, nvim-lspconfig, fidget; all server configs |
| `lua/plugins/formatting.lua` | conform.nvim with full formatters_by_ft |
| `lua/plugins/linting.lua` | nvim-lint with linters_by_ft |
| `lua/plugins/dap.lua` | nvim-dap, dap-ui, mason-nvim-dap, nvim-dap-virtual-text; js/php adapters |
| `lua/plugins/git.lua` | neogit + diffview |
| `lua/plugins/snacks.lua` | folke/snacks.nvim (bigfile, notifier, quickfile, statuscolumn, indent, words, dashboard) |
| `lua/plugins/lang/rust.lua` | rustaceanvim, crates.nvim |
| `lua/plugins/lang/go.lua` | go.nvim + guihua.lua, nvim-dap-go |
| `lua/plugins/lang/typescript.lua` | typescript-tools.nvim, package-info.nvim |
| `lua/plugins/lang/vue.lua` | Comments only — Vue handled via volar+typescript-tools |
| `lua/plugins/lang/php.lua` | laravel.nvim |
| `lua/plugins/lang/web.lua` | tailwind-tools.nvim |

### Deleted
- `lua/custom/plugins/hop.lua` — replaced by flash.nvim
- `lua/custom/plugins/oil.lua` — moved to editor.lua
- `lua/custom/plugins/ts-lsp.lua` — moved to lang/typescript.lua
- `lua/custom/plugins/init.lua` — empty, no longer needed
- `lua/custom/plugins/` and `lua/custom/` directories

### Key changes / fixes
- **Bug fixed**: `stylua = {}` removed from LSP servers table (was invalid — stylua is a formatter, not an LSP). Now lives in mason-tool-installer `ensure_installed` list.
- **hop.nvim removed**: `f/F/t/T` override keymaps at bottom of init.lua are gone. flash.nvim provides `s/S/r/R` motions.
- **neo-tree**: The kickstart neo-tree import was present and loaded. It is now dropped (not included in new plugin files). Oil remains as the file explorer.
- **indent-blankline.nvim**: Dropped in favor of snacks.indent.
- **Folding**: nvim-ufo configured with LSP+indent providers; `foldlevel=99` set in options so all folds open by default.
- **Inlay hints**: `<leader>uh` toggles globally (changed from per-buffer `<leader>th`).
- **LSP capabilities**: Centralized via `blink.cmp.get_lsp_capabilities()` and passed to all servers.
- **volar hybrid mode**: `vue.server.hybridMode = true`. typescript-tools loads `@vue/typescript-plugin`.
- **intelephense**: `root_dir` includes `artisan` for Laravel projects.
- **tailwindcss**: Extended filetypes include blade, vue, php.
- **DAP**: codelldb, js-debug-adapter, php-debug-adapter, delve all ensured via mason-nvim-dap. Rust DAP wired automatically by rustaceanvim.

## What to run after opening Neovim

1. `:Lazy sync` — installs/updates all plugins
2. `:Mason` — verify all tools were installed (or `:MasonInstall` for any that failed)
3. `:TSUpdate` — ensure all treesitter parsers are current
4. `:checkhealth` — review any warnings (especially for mason, treesitter, LSPs)
5. `:checkhealth blink.cmp` — verify completion is working
6. Install Node.js packages for Vue support: `npm i -g @vue/typescript-plugin @styled/typescript-styled-plugin`

## which-key groups
| Prefix | Group |
|---|---|
| `<leader>c` | Code |
| `<leader>f` | Find / Format |
| `<leader>g` | Git |
| `<leader>x` | Trouble |
| `<leader>d` | Debug |
| `<leader>s` | Search |
| `<leader>h` | Harpoon / Git Hunk |
| `<leader>u` | UI Toggles |
| `<leader>l` | Lazy |
