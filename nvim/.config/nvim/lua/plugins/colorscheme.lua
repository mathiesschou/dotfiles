return {
	{ 
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		integrations = {
			bufferline = true,
		},
		config = function()
			vim.cmd([[colorscheme catppuccin-mocha]])
		end,	
	},
	{
		"sainnhe/gruvbox-material",
		name = "gruvbox-material",
		lazy = false,
	},
}
