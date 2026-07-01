-- Core keymaps (no plugins). <leader> is space.
local map = vim.keymap.set

-- Clear search highlight with Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save / quit
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })

-- Window navigation is handled by vim-tmux-navigator (<C-h/j/k/l>).

-- Resize splits with Ctrl + arrow keys
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
