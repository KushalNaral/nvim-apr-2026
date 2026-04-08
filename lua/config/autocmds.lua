-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Close certain filetypes with just 'q'
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close-with-q', { clear = true }),
  pattern = { 'help', 'man', 'qf', 'lspinfo', 'startuptime', 'checkhealth', 'notify' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Auto-resize splits on VimResized
vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('resize-splits', { clear = true }),
  callback = function()
    vim.cmd 'tabdo wincmd ='
  end,
})
