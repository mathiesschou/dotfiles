-- Core editor settings (no plugins). Tweak freely.
local opt = vim.opt

opt.number = true          -- show line numbers
opt.relativenumber = true  -- relative numbers for easy motions
opt.mouse = "a"            -- enable mouse
opt.clipboard = "unnamedplus" -- use system clipboard
opt.ignorecase = true     -- case-insensitive search...
opt.smartcase = true      -- ...unless the query has capitals
opt.termguicolors = true  -- 24-bit colors
opt.signcolumn = "yes"    -- always show the sign column
opt.cursorline = true     -- highlight current line
opt.cursorlineopt = "number,line" -- highlight line text and line number
opt.colorcolumn = "80"    -- show a vertical guide at 80 characters
opt.scrolloff = 8         -- keep lines of context around the cursor
opt.splitright = true     -- vertical splits open to the right
opt.splitbelow = true     -- horizontal splits open below
opt.undofile = true       -- persistent undo history

-- Indentation
opt.expandtab = true      -- spaces instead of tabs
opt.shiftwidth = 4        -- size of an indent
opt.tabstop = 4           -- a tab counts for 4 spaces
opt.smartindent = true    -- auto-indent new lines

vim.g.mapleader = " "     -- space as leader key
vim.g.maplocalleader = " "
