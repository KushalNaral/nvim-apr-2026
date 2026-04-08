return {
  -- Telescope fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    enabled = true,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      local map = vim.keymap.set
      map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
      map('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
      map('n', '<leader>st', function() vim.cmd 'TodoTelescope' end, { desc = '[S]earch [T]odos' })
      map('n', '<leader>so', function() vim.cmd 'TodoLocList' end, { desc = '[S]earch Todo [O]pen list' })
      map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      map('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      map('n', '<leader>s/', function()
        builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end, { desc = '[S]earch [/] in Open Files' })

      map('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      -- LSP-specific telescope pickers (registered on LspAttach)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf
          map('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
          map('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
          map('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
          map('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
          map('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
          map('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })
    end,
  },

  -- Oil file explorer (replaces netrw)
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      default_file_explorer = true,
      columns = { 'icon', 'size', 'mtime' },
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },
      win_options = {
        wrap = false,
        signcolumn = 'no',
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
      },
      delete_to_trash = false,
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms = 2000,
      constrain_cursor = 'editable',
      watch_for_changes = false,
      use_default_keymaps = true,
      view_options = {
        show_hidden = false,
        natural_order = 'fast',
        case_insensitive = false,
        sort = {
          { 'type', 'asc' },
          { 'name', 'asc' },
        },
      },
    },
  },

  -- Gitsigns
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then vim.cmd.normal { ']c', bang = true }
          else gitsigns.nav_hunk 'next' end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then vim.cmd.normal { '[c', bang = true }
          else gitsigns.nav_hunk 'prev' end
        end, { desc = 'Jump to previous git [c]hange' })

        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline' })
        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
        map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end)
        map('n', '<leader>hq', gitsigns.setqflist)
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tw', gitsigns.toggle_word_diff)
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end,
    },
  },

  -- Todo comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Oil (file explorer)
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open parent directory (Oil)' },
    },
    opts = {
      default_file_explorer = true,
      columns = { 'icon', 'size', 'mtime' },
      delete_to_trash = false,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = false,
      },
    },
  },

  -- Hop (motion)
  {
    'smoka7/hop.nvim',
    version = '*',
    event = 'VeryLazy',
    opts = {
      keys = 'etovxqpdygfblzhckisuran',
    },
    keys = {
      { 's', '<cmd>HopWord<cr>', mode = { 'n', 'x', 'o' }, desc = 'Hop word' },
      { 'S', '<cmd>HopLine<cr>', mode = { 'n', 'x', 'o' }, desc = 'Hop line' },
      { 'f', '<cmd>HopChar1CurrentLineAC<cr>', mode = { 'n', 'x', 'o' }, desc = 'Hop char (line, fwd)' },
      { 'F', '<cmd>HopChar1CurrentLineBC<cr>', mode = { 'n', 'x', 'o' }, desc = 'Hop char (line, back)' },
      { '<leader>j', '<cmd>HopChar2<cr>', mode = { 'n', 'x', 'o' }, desc = 'Hop 2-char' },
    },
  },

  -- Harpoon2
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()
      local map = vim.keymap.set
      map('n', '<leader>ha', function() harpoon:list():add() end, { desc = '[H]arpoon [A]dd' })
      map('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[H]arpoon toggle list' })
      map('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon file 1' })
      map('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon file 2' })
      map('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon file 3' })
      map('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon file 4' })
    end,
  },

  -- Trouble
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
  },

  -- Grug-far search & replace
  {
    'MagicDuck/grug-far.nvim',
    keys = {
      { '<leader>sr', function() require('grug-far').open() end, desc = '[S]earch and [R]eplace (grug-far)' },
    },
    opts = {},
  },
}
