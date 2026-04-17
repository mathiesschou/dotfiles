vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("v", "jk", "<Esc>", { desc = "Exit visual mode" })

vim.keymap.set("n", "<M-Left>", "<C-w><", { desc = "Resize split left" })
vim.keymap.set("n", "<M-Right>", "<C-w>>", { desc = "Resize split right" })
vim.keymap.set("n", "<M-Up>", "<C-w>+", { desc = "Resize split up" })
vim.keymap.set("n", "<M-Down>", "<C-w>-", { desc = "Resize split down" })