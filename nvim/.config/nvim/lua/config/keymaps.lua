local map = vim.keymap.set
local opt = { noremap = true, silent = true }

vim.g.mapleader = " "
-- Insert to normal mode
map("i", "jk", "<ESC>", opt)

-- Navigate splits
map("n", "<C-h>", "<C-w>h", opt)
map("n", "<C-j>", "<C-w>j", opt)
map("n", "<C-k>", "<C-w>k", opt)
map("n", "<C-l>", "<C-w>l", opt)

-- Split a window
map("n", "<leader>h", "<C-w>s", opt) -- Horisontal split
map("n", "<leader>v", "<C-w>v", opt) -- Vertical split

-- Close current buffer
vim.keymap.set("n", "<leader>q", ":bd<CR>", { noremap = true, silent = true }) 

-- Yank text til system clipboard
vim.api.nvim_set_keymap(
	"v",
	"<leader>y",
	":'<,'>w !pbcopy<CR>",
	{ noremap = true, silent = true }
)

-- Move selected text up and down
map("v", "J", ":m '>+1<CR>gv=gv", opt)
map("v", "K", ":m '<-2<CR>gv=gv", opt)

-- Markdown preview
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.keymap.set("n", "<leader>md", ":MarkdownPreviewToggle<CR>", { noremap = true, silent = true, buffer = true, desc = "Toggle Markdown Preview" })
    end,
})

-- Toogle Twillight 
vim.keymap.set("n", "<leader>mn", function()
    vim.cmd("TwilightEnable")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>mb", function()
    vim.cmd("TwilightDisable")
end, { noremap = true, silent = true })
