local map = vim.keymap.set

-- Clear search highlights
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic quickfix
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal escape
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Format buffer
map('', '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })

-- Inlay hint toggle
map('n', '<leader>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {}) end, { desc = 'Toggle Inlay [H]ints' })

-- Save file with Ctrl + S in Normal, Insert, and Visual modes
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })
