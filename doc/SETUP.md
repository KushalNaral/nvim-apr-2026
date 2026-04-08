# Neovim Setup & Keybindings

Polyglot IDE for **Rust, Go, TypeScript, React, Vue, Laravel/PHP, Lua**.
Built on kickstart.nvim, refactored into a modular layout.

Leader key: `<Space>`

---

## Table of Contents
1. [Architecture](#architecture)
2. [Installed Tooling](#installed-tooling)
3. [Keybindings](#keybindings)
4. [Post-install commands](#post-install-commands)

---

## Architecture

```
init.lua                       bootstrap → loads config.* then lazy
lua/config/
  options.lua                  vim.opt.*, diagnostics, folding
  keymaps.lua                  global keymaps
  autocmds.lua                 yank highlight, close-with-q, splits
  lazy.lua                     lazy bootstrap + plugin imports
lua/plugins/
  ui.lua                       tokyonight, which-key, mini.*, guess-indent
  editor.lua                   telescope, oil, gitsigns, todo, flash, harpoon, trouble, grug-far
  coding.lua                   blink.cmp, autopairs, ts-autotag, ufo
  treesitter.lua               nvim-treesitter (main) + textobjects
  lsp.lua                      mason, lspconfig, fidget, all server configs
  formatting.lua               conform.nvim
  linting.lua                  nvim-lint
  dap.lua                      nvim-dap, dap-ui, virtual-text, adapters
  git.lua                      neogit + diffview
  snacks.lua                   bigfile, notifier, quickfile, statuscolumn, indent, words, dashboard
  lang/
    rust.lua                   rustaceanvim, crates.nvim
    go.lua                     go.nvim, nvim-dap-go
    typescript.lua             typescript-tools, package-info
    vue.lua                    (volar lives in lsp.lua)
    php.lua                    laravel.nvim
    web.lua                    tailwind-tools
```

---

## Installed Tooling

### LSP servers (auto-installed via mason)
| Server | Languages |
|---|---|
| `lua_ls` | Lua |
| `gopls` | Go |
| `volar` | Vue (hybrid mode) |
| `intelephense` | PHP / Laravel (root_dir aware of `artisan`) |
| `tailwindcss` | Tailwind (HTML, Vue, JSX/TSX, Blade, PHP, CSS) |
| `emmet_language_server` | HTML/CSS/JSX expansion |
| `eslint` | JS/TS linting + code actions |
| `html`, `cssls`, `jsonls`, `yamlls`, `bashls` | web/data/shell |
| `rust_analyzer` | Rust — owned by **rustaceanvim** (not lspconfig) |
| `typescript-tools.nvim` | TS/JS/TSX/JSX/Vue — replaces `ts_ls` |

### Formatters (conform.nvim)
- **Lua** stylua
- **Rust** rustfmt
- **Go** goimports + gofumpt
- **JS/TS/JSX/TSX/Vue/CSS/SCSS/HTML/JSON/YAML/MD/GraphQL** prettierd → prettier
- **PHP** pint → php-cs-fixer
- **Blade** blade-formatter
- **Shell** shfmt

Format-on-save enabled (LSP fallback). Skipped for `c`/`cpp`.

### Linters (nvim-lint)
- **PHP** phpstan
- **Go** golangci-lint
- **Markdown** markdownlint
- **Shell** shellcheck
- **Dockerfile** hadolint
- **JS/TS** via ESLint LSP (not eslint_d)

### DAP adapters
- **codelldb** Rust / C / C++ (auto-wired by rustaceanvim)
- **delve** Go (via nvim-dap-go)
- **js-debug-adapter** Node / browser
- **php-debug-adapter** Xdebug (port 9003)

### Treesitter parsers
bash, c, lua, luadoc, vim, vimdoc, query, diff, html, markdown, markdown_inline, rust, ron, toml, go, gomod, gosum, gowork, javascript, typescript, tsx, jsdoc, vue, css, scss, php, phpdoc, json, jsonc, yaml, dockerfile, gitcommit, gitignore, regex, sql, prisma, graphql + **textobjects**.

---

## Keybindings

### Leader Groups (which-key)
| Prefix | Group |
|---|---|
| `<leader>c` | Code |
| `<leader>f` | Find / Format |
| `<leader>g` | Git |
| `<leader>x` | Trouble |
| `<leader>d` | Debug |
| `<leader>s` | Search |
| `<leader>h` | Harpoon / Git Hunks |
| `<leader>u` | UI Toggles |
| `<leader>l` | Lazy / Laravel |

### General
| Key | Action |
|---|---|
| `<Esc>` | Clear search highlights |
| `<Esc><Esc>` (terminal) | Exit terminal mode |
| `<C-h/j/k/l>` | Move focus to left/down/up/right window |
| `<leader>q` | Open diagnostic quickfix list |
| `<leader>f` | Format buffer (conform) |
| `<leader>uh` | Toggle inlay hints |

### Search / Telescope (`<leader>s`)
| Key | Action |
|---|---|
| `<leader>sh` | Search help |
| `<leader>sk` | Search keymaps |
| `<leader>sf` | Search files |
| `<leader>ss` | Telescope builtins |
| `<leader>sw` | Search current word |
| `<leader>sg` | Live grep |
| `<leader>sd` | Search diagnostics |
| `<leader>sr` | Search & Replace (grug-far) |
| `<leader>s.` | Recent files |
| `<leader>sc` | Search commands |
| `<leader>st` | Search TODOs |
| `<leader>so` | TODO loclist |
| `<leader>sn` | Search Neovim config files |
| `<leader>/`  | Fuzzy search current buffer |
| `<leader>s/` | Live grep open files |
| `<leader><leader>` | Find existing buffers |

### LSP (active when LSP attaches)
| Key | Action |
|---|---|
| `grn` | Rename symbol |
| `gra` | Code action (n+x) |
| `grr` | Goto references |
| `gri` | Goto implementation |
| `grd` | Goto definition |
| `grD` | Goto declaration |
| `grt` | Goto type definition |
| `gO`  | Document symbols |
| `gW`  | Workspace symbols |
| `K`   | Hover docs (Rust uses rustaceanvim hover) |

### Code (`<leader>c`)
TypeScript / JS / Vue (via typescript-tools):
| Key | Action |
|---|---|
| `<leader>co` | Organize imports |
| `<leader>cR` | Remove unused |
| `<leader>cF` | Fix all |
| `<leader>cA` | Add missing imports |
| `<leader>cr` | Rename file |

Rust (via rustaceanvim):
| Key | Action |
|---|---|
| `<leader>ca` | Rust code action |
| `<leader>ce` | Explain error |
| `<leader>cd` | Render diagnostic |
| `K` | Rust hover actions |

### Git (`<leader>g` and `<leader>h`)
| Key | Action |
|---|---|
| `<leader>gg` | Open Neogit |
| `<leader>gd` | Diffview open |
| `<leader>gD` | Diffview close |
| `<leader>gh` | File history |
| `<leader>hs` | Stage hunk (n+v) |
| `<leader>hr` | Reset hunk (n+v) |
| `<leader>hS` | Stage buffer |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hi` | Preview hunk inline |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff against index |
| `<leader>hD` | Diff against last commit |
| `<leader>tb` | Toggle line blame |
| `]c` / `[c` | Next/prev git change |

### Harpoon (`<leader>h` shared with hunks; harpoon uses `ha`/`hh`)
| Key | Action |
|---|---|
| `<leader>ha` | Add file to harpoon |
| `<leader>hh` | Toggle harpoon list |
| `<leader>1..4` | Jump to harpoon file 1–4 |

### Trouble (`<leader>x`)
| Key | Action |
|---|---|
| `<leader>xx` | Diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xs` | Symbols |
| `<leader>xl` | LSP defs/refs |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |

### Debug (`<leader>d` + F-keys)
| Key | Action |
|---|---|
| `<F5>` / `<leader>dc` | Continue |
| `<F1>` | Step into |
| `<F2>` | Step over |
| `<F3>` | Step out |
| `<F7>` / `<leader>dt` | Toggle DAP UI |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Conditional breakpoint |

### Flash (motion) — replaces hop
| Key | Mode | Action |
|---|---|---|
| `s` | n/x/o | Flash jump |
| `S` | n/x/o | Flash treesitter |
| `r` | o | Remote flash |
| `R` | o/x | Treesitter search |

### Folding (nvim-ufo)
| Key | Action |
|---|---|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zr` | Open folds except kinds |

### Laravel (`<leader>l`, ft=php/blade)
| Key | Action |
|---|---|
| `<leader>la` | Laravel artisan |
| `<leader>lr` | Laravel routes |

### File Explorer
- **oil.nvim** — open with `-` (oil default) for parent directory edit-as-buffer.

---

## Post-install commands

After first launch:
1. `:Lazy sync` — install/update plugins
2. `:Mason` — verify LSPs/formatters/linters/DAP installed
3. `:TSUpdate` — update treesitter parsers
4. `:checkhealth` — review warnings
5. Install Vue TS plugin globally: `npm i -g @vue/typescript-plugin @styled/typescript-styled-plugin`

---

## Notes
- **Rust**: do not enable `rust_analyzer` via lspconfig — rustaceanvim owns it.
- **TypeScript**: do not enable `ts_ls` or `vtsls` — typescript-tools.nvim owns TS/Vue.
- **Vue**: hybrid mode — volar handles `.vue`, typescript-tools handles `.ts` with `@vue/typescript-plugin`.
- **PHP/Laravel**: intelephense roots on `artisan`/`composer.json`/`.git`.
- **Folding**: opens fully by default (`foldlevel=99`); use `zM` to fold all.
