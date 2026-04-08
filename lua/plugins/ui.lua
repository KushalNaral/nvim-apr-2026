return {
  -- Colorscheme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        variant = 'main',
        dark_variant = 'main',
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true,
          migrations = true,
        },

        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },

        groups = {
          border = 'muted',
          link = 'iris',
          panel = 'surface',

          error = 'love',
          hint = 'iris',
          info = 'foam',
          note = 'pine',
          todo = 'rose',
          warn = 'gold',

          git_add = 'foam',
          git_change = 'rose',
          git_delete = 'love',
          git_dirty = 'rose',
          git_ignore = 'muted',
          git_merge = 'iris',
          git_rename = 'pine',
          git_stage = 'iris',
          git_text = 'rose',
          git_untracked = 'subtle',

          h1 = 'iris',
          h2 = 'foam',
          h3 = 'rose',
          h4 = 'gold',
          h5 = 'pine',
          h6 = 'foam',
        },
      }
      vim.cmd 'colorscheme rose-pine'
    end,
  },

  -- Folds (nvim-ufo)
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = 'BufReadPost',
    init = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      require('ufo').setup {
        provider_selector = function() return { 'treesitter', 'indent' } end,
      }
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
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
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },

  -- Indent guides (snacks.indent handles this, but keep ibl as fallback/complement)
  { 'NMAC427/guess-indent.nvim', opts = {} },
}
