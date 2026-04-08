-- AI / inline completions (Codeium via neocodeium)
return {
  {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local neocodeium = require 'neocodeium'
      neocodeium.setup()
      vim.keymap.set('i', '<A-l>', neocodeium.accept, { desc = 'NeoCodeium accept' })
      vim.keymap.set('i', '<A-w>', neocodeium.accept_word, { desc = 'NeoCodeium accept word' })
      vim.keymap.set('i', '<A-a>', neocodeium.accept_line, { desc = 'NeoCodeium accept line' })
      vim.keymap.set('i', '<A-]>', function() neocodeium.cycle_or_complete(1) end, { desc = 'NeoCodeium next' })
      vim.keymap.set('i', '<A-[>', function() neocodeium.cycle_or_complete(-1) end, { desc = 'NeoCodeium prev' })
      vim.keymap.set('i', '<A-c>', neocodeium.clear, { desc = 'NeoCodeium clear' })
    end,
  },
}
