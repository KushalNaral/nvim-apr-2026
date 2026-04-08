return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      indent = { enabled = true },
      words = { enabled = true },
      --Dashboard
      dashboard = {
        enabled = true,
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { section = 'startup' },
        },
      },
      -- Disabled: using telescope for picking, builtin vim.ui.input
      input = { enabled = false },
      picker = { enabled = false },
    },
  },
}
