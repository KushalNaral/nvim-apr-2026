return {
  -- typescript-tools: replaces ts_ls / tsserver. Do NOT enable vtsls/ts_ls alongside this.
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
    opts = {
      on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map('n', '<leader>co', '<cmd>TSToolsOrganizeImports<cr>', 'Organize Imports')
        map('n', '<leader>cR', '<cmd>TSToolsRemoveUnused<cr>', 'Remove Unused')
        map('n', '<leader>cF', '<cmd>TSToolsFixAll<cr>', 'Fix All')
        map('n', '<leader>cA', '<cmd>TSToolsAddMissingImports<cr>', 'Add Missing Imports')
        map('n', '<leader>cr', '<cmd>TSToolsRenameFile<cr>', 'Rename File')
      end,
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = 'insert_leave',
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_format_options = {},
        jsx_close_tag = {
          enable = true,
          filetypes = { 'javascriptreact', 'typescriptreact', 'vue' },
        },
        -- @vue/typescript-plugin enables Vue support in TS files via hybrid mode
        tsserver_plugins = {
          '@vue/typescript-plugin',
          '@styled/typescript-styled-plugin',
          ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        },
      },
    },
  },

  -- package.json dependency info
  {
    'vuki656/package-info.nvim',
    event = 'BufRead package.json',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
}
