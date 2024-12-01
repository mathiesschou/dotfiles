return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function() 
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			-- TS languages
			ensure_installed = { "lua", "vim", "python", "markdown" },
		})
	end
}
