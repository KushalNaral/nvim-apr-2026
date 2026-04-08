return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufWritePost', 'InsertLeave' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        -- JS/TS: rely on eslint LSP instead of a separate linter process
        javascript = {},
        typescript = {},
        javascriptreact = {},
        typescriptreact = {},
        vue = {},
        php = { 'phpstan' },
        go = { 'golangcilint' },
        markdown = { 'markdownlint' },
        sh = { 'shellcheck' },
        dockerfile = { 'hadolint' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
