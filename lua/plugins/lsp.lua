return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- Central capabilities (blink.cmp extends LSP defaults)
      local capabilities = require('blink.cmp').get_lsp_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
      -- nvim-ufo folding capabilities
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- LSP attach: shared keymaps across all servers
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local hl_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = hl_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = hl_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- Server configs
      -- Note: rust_analyzer is NOT here — rustaceanvim owns it.
      -- Note: ts_ls / vtsls are NOT here — typescript-tools.nvim owns TS.
      local servers = {
        gopls = {},

        -- Volar (Vue, hybrid mode — works alongside typescript-tools)
        volar = {
          settings = {
            vue = {
              server = { hybridMode = true },
            },
          },
          filetypes = { 'vue' },
        },

        intelephense = {
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern('artisan', 'composer.json', '.git')(fname)
          end,
        },

        tailwindcss = {
          filetypes = {
            'html', 'css', 'scss', 'javascript', 'javascriptreact',
            'typescript', 'typescriptreact', 'vue', 'blade', 'php',
          },
        },

        emmet_language_server = {},
        eslint = {},
        html = {},
        cssls = {},
        jsonls = {},
        yamlls = {},
        bashls = {},

        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config'
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
              then
                return
              end
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = { 'lua/?.lua', 'lua/?/init.lua' },
              },
              workspace = {
                checkThirdParty = false,
                library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                }),
              },
            })
          end,
          settings = { Lua = {} },
        },
      }

      -- mason-tool-installer: LSP servers + standalone tools
      -- Mason package names differ from lspconfig server names for some servers.
      local mason_names = {}
      for name in pairs(servers) do
        if name == 'volar' then
          table.insert(mason_names, 'vue-language-server')
        else
          table.insert(mason_names, name)
        end
      end
      require('mason-tool-installer').setup {
        ensure_installed = vim.list_extend(mason_names, {
          -- Formatters
          'stylua',
          'prettierd',
          'gofumpt',
          'goimports',
          'php-cs-fixer',
          'pint',
          'blade-formatter',
          'shfmt',
          -- Linters
          'phpstan',
          'golangci-lint',
          'markdownlint',
          'shellcheck',
          'hadolint',
        }),
      }

      -- Register and enable each server
      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },
}
