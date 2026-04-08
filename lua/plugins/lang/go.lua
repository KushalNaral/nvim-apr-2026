return {
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      lsp_cfg = false, -- gopls is managed by nvim-lspconfig in lsp.lua
      lsp_gofumpt = true,
      lsp_on_attach = false,
    },
  },

  -- Go DAP (delve)
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = { 'mfussenegger/nvim-dap' },
    opts = {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    },
  },
}
