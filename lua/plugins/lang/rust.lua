return {
  -- rustaceanvim owns rust_analyzer — do NOT configure rust_analyzer in lsp.lua
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    ft = 'rust',
    -- rustaceanvim auto-wires codelldb for DAP
    opts = {
      server = {
        on_attach = function(_, bufnr)
          local map = vim.keymap.set
          map('n', '<leader>ca', function() vim.cmd.RustLsp 'codeAction' end, { buffer = bufnr, desc = 'Rust Code Action' })
          map('n', '<leader>ce', function() vim.cmd.RustLsp 'explainError' end, { buffer = bufnr, desc = 'Rust Explain Error' })
          map('n', '<leader>cd', function() vim.cmd.RustLsp 'renderDiagnostic' end, { buffer = bufnr, desc = 'Rust Render Diagnostic' })
          map('n', 'K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, { buffer = bufnr, desc = 'Rust Hover' })
        end,
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts)
    end,
  },

  -- Cargo.toml dependency management
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = {
        cmp = { enabled = false },
        crates = { enabled = true },
      },
    },
  },
}
