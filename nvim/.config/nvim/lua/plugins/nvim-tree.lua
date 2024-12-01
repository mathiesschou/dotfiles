return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	-- Keymaps toggle nvim-tree
	keys = {
		vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeToggle<CR>", { noremap = false, silent = true })
	},
	config = function()
		require("nvim-tree").setup {}
		 
	end
}
