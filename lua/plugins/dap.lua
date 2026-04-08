return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      -- Virtual text showing variable values inline
      { 'theHamsta/nvim-dap-virtual-text', opts = {} },
    },
    keys = {
      { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
      { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
      { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
      { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
      { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
      { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint' },
      { '<F7>', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
      { '<leader>dc', function() require('dap').continue() end, desc = '[D]ebug [C]ontinue' },
      { '<leader>dt', function() require('dapui').toggle() end, desc = '[D]ebug [T]oggle UI' },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          'codelldb',
          'js-debug-adapter',
          'php-debug-adapter',
          'delve',
        },
      }

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸', play = '▶', step_into = '⏎', step_over = '⏭',
            step_out = '⏮', step_back = 'b', run_last = '▶▶', terminate = '⏹', disconnect = '⏏',
          },
        },
      }

      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- JS/TS debug adapter (js-debug-adapter)
      for _, adapter in ipairs { 'node', 'chrome', 'pwa-node', 'pwa-chrome' } do
        dap.adapters[adapter] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'node',
            args = {
              vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
              '${port}',
            },
          },
        }
      end
      for _, lang in ipairs { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } do
        dap.configurations[lang] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Launch Chrome',
            url = 'http://localhost:3000',
            webRoot = '${workspaceFolder}',
          },
        }
      end

      -- PHP debug adapter (Xdebug port 9003)
      dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { vim.fn.stdpath 'data' .. '/mason/packages/php-debug-adapter/extension/out/phpDebug.js' },
      }
      dap.configurations.php = {
        {
          type = 'php',
          request = 'launch',
          name = 'Listen for Xdebug',
          port = 9003,
        },
      }

      -- Rust DAP is wired automatically by rustaceanvim via codelldb
    end,
  },
}
