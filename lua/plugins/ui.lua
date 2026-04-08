return {
  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = true },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Which-key
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>c', group = '[C]ode' },
        { '<leader>f', group = '[F]ind / Format' },
        { '<leader>g', group = '[G]it' },
        { '<leader>x', group = 'Trouble [X]' },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>h', group = '[H]arpoon / Git Hunk', mode = { 'n', 'v' } },
        { '<leader>u', group = '[U]I Toggles' },
        { '<leader>l', group = '[L]azy' },
        { '<leader>t', group = '[T]oggle' },
        { 'gr', group = 'LSP Actions' },
      },
    },
  },

  -- Mini statusline (keep; no lualine)
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Indent guides (snacks.indent handles this, but keep ibl as fallback/complement)
  { 'NMAC427/guess-indent.nvim', opts = {} },
}
