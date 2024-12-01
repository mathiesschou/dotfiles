local opt = vim.opt

-- Line number
opt.number = true
opt.relativenumber = true

-- Clipboard
opt.clipboard = unamed, unnamedplus

-- / Search options
opt.ignorecase = true
opt.smartcase = true

-- Tab options
opt.shiftwidth = 4 -- Num of spaces for autoindent
opt.tabstop = 4 -- Num of spaces a tab counts for

-- Swap files
opt.swapfile = false

-- Split options
opt.splitright = true
opt.splitbelow = true
