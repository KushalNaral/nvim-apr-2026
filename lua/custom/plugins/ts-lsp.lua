return {
  -- typescript-tools.nvim setup (replaces plain ts_ls / tsserver)
  {
    'pmizio/typescript-tools.nvim',
    opts = {
      on_attach = function(client, bufnr)
        -- Optional: disable built-in formatting if you use null-ls / conform.nvim / prettier
        -- client.server_capabilities.documentFormattingProvider = false
        -- client.server_capabilities.documentRangeFormattingProvider = false

        -- Common keymaps (you can customize)
        local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

        map('n', '<leader>co', '<cmd>TSToolsOrganizeImports<cr>', 'Organize Imports')
        map('n', '<leader>cR', '<cmd>TSToolsRemoveUnused<cr>', 'Remove Unused')
        map('n', '<leader>cF', '<cmd>TSToolsFixAll<cr>', 'Fix All')
        map('n', '<leader>cA', '<cmd>TSToolsAddMissingImports<cr>', 'Add Missing Imports')
        map('n', '<leader>cr', '<cmd>TSToolsRenameFile<cr>', 'Rename File')
      end,

      handlers = {
        -- You can add custom handlers here if needed
      },

      settings = {
        -- Global settings
        separate_diagnostic_server = true,
        publish_diagnostic_on = 'insert_leave',

        -- tsserver settings
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },

        tsserver_format_options = {
          -- You can tweak formatting here (but most people use Prettier via conform/null-ls)
        },

        -- Good defaults for React + Vue + TS
        jsx_close_tag = {
          enable = true,
          filetypes = { 'javascriptreact', 'typescriptreact', 'vue' },
        },

        -- Enable support for Vue via the official @vue/typescript-plugin
        tsserver_plugins = {
          '@vue/typescript-plugin',
          '@styled/typescript-styled-plugin',
          ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        },
      },
    },
  },
}
