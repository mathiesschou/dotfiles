-- Options
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.wrap = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.shortmess:append("I") -- Disable intro message
opt.shortmess:append("c") -- Don't show completion messages
opt.shortmess:append("F") -- Don't show file info when editing
