return {
  {
    'adalessa/laravel.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'tpope/vim-dotenv',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
    },
    ft = { 'php', 'blade' },
    cmd = { 'Laravel' },
    keys = {
      { '<leader>la', '<cmd>Laravel artisan<cr>', desc = '[L]aravel [A]rtisan' },
      { '<leader>lr', '<cmd>Laravel routes<cr>', desc = '[L]aravel [R]outes' },
    },
    opts = {},
  },
}
