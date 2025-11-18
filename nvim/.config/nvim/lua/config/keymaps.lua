-- Keymaps
local map = vim.keymap.set

-- Window navigation is handled by vim-tmux-navigator plugin
-- See lua/plugins/tmux-navigator.lua

-- Exit to normal mode
map("i", "jk", "<ESC>", { desc = "Insert mode to normal mode" })

-- Save file
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Quit
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
