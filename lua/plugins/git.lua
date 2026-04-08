return {
  -- Neogit
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      integrations = { diffview = true, telescope = true },
    },
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = '[G]it Neogit' },
    },
  },

  -- Diffview (standalone: available even without neogit)
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iffview open' },
      { '<leader>gD', '<cmd>DiffviewClose<cr>', desc = '[G]it [D]iffview close' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory' },
    },
    opts = {},
  },
}
