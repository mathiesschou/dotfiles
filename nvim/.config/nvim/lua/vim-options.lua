-- vim options
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true

local opts = { noremap = true, silent = true }

-- vim panes navigation
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', opts)

-- insert mode to normal mode
vim.keymap.set('i', 'jk', '<ESC>', opts)

-- leaderkey
vim.g.mapleader = " "


